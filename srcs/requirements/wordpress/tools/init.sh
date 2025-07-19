#!/bin/bash

# Script d'initialisation pour WordPress

# Vérifier les variables d'environnement requises
if [ -z "$WORDPRESS_DB_NAME" ] || [ -z "$WORDPRESS_DB_USER" ] || [ -z "$WORDPRESS_DB_PASSWORD" ] || [ -z "$WORDPRESS_DB_HOST" ]; then
    echo "Erreur: Variables d'environnement de base de données manquantes"
    echo "Requis: WORDPRESS_DB_NAME, WORDPRESS_DB_USER, WORDPRESS_DB_PASSWORD, WORDPRESS_DB_HOST"
    exit 1
fi

# Attendre que MariaDB soit prêt
echo "Attente de la disponibilité de MariaDB..."
while ! nc -z ${WORDPRESS_DB_HOST%:*} ${WORDPRESS_DB_HOST#*:} 2>/dev/null; do
    echo "MariaDB n'est pas encore prêt, attente..."
    sleep 2
done
echo "MariaDB est disponible!"

# Vérifier si WordPress est déjà installé
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Installation de WordPress..."
    
    # Télécharger WordPress
    cd /tmp
    wget -O wordpress.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf wordpress.tar.gz
    
    # Copier WordPress
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress wordpress.tar.gz
    
    # Copier le fichier de configuration
    cp /usr/local/bin/wp-config.php /var/www/html/wp-config.php
    
    # Générer les clés de sécurité
    echo "Génération des clés de sécurité..."
    
    # Télécharger et appliquer les clés de sécurité
    curl -s https://api.wordpress.org/secret-key/1.1/salt/ > /tmp/wp-salts.txt
    
    # Remplacer les clés dans le fichier de configuration
    sed -i '/AUTH_KEY/c\'"$(grep "define('AUTH_KEY'" /tmp/wp-salts.txt)"'' /var/www/html/wp-config.php
    sed -i '/SECURE_AUTH_KEY/c\'"$(grep "define('SECURE_AUTH_KEY'" /tmp/wp-salts.txt)"'' /var/www/html/wp-config.php
    sed -i '/LOGGED_IN_KEY/c\'"$(grep "define('LOGGED_IN_KEY'" /tmp/wp-salts.txt)"'' /var/www/html/wp-config.php
    sed -i '/NONCE_KEY/c\'"$(grep "define('NONCE_KEY'" /tmp/wp-salts.txt)"'' /var/www/html/wp-config.php
    sed -i '/AUTH_SALT/c\'"$(grep "define('AUTH_SALT'" /tmp/wp-salts.txt)"'' /var/www/html/wp-config.php
    sed -i '/SECURE_AUTH_SALT/c\'"$(grep "define('SECURE_AUTH_SALT'" /tmp/wp-salts.txt)"'' /var/www/html/wp-config.php
    sed -i '/LOGGED_IN_SALT/c\'"$(grep "define('LOGGED_IN_SALT'" /tmp/wp-salts.txt)"'' /var/www/html/wp-config.php
    sed -i '/NONCE_SALT/c\'"$(grep "define('NONCE_SALT'" /tmp/wp-salts.txt)"'' /var/www/html/wp-config.php
    
    rm -f /tmp/wp-salts.txt
    
    # Installer WP-CLI
    echo "Installation de WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/bin/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    
    # Attendre un peu plus pour s'assurer que la base de données est prête
    sleep 5
    
    # Installer WordPress via WP-CLI
    echo "Configuration de WordPress..."
    cd /var/www/html
    
    # Installation de WordPress
    wp core install \
        --url="${WORDPRESS_URL:-https://localhost}" \
        --title="${WORDPRESS_TITLE:-Mon Site WordPress}" \
        --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD:-adminpassword}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
        --allow-root
    
    # Créer un utilisateur supplémentaire si spécifié
    if [ -n "$WORDPRESS_USER" ] && [ -n "$WORDPRESS_USER_PASSWORD" ]; then
        wp user create \
            "${WORDPRESS_USER}" \
            "${WORDPRESS_USER_EMAIL:-user@example.com}" \
            --role=author \
            --user_pass="${WORDPRESS_USER_PASSWORD}" \
            --allow-root
    fi
    
    # Configuration des permaliens
    wp rewrite structure '/%postname%/' --allow-root
    
    # Activer des plugins de base
    wp plugin install akismet --activate --allow-root
    
    # Configuration de Redis
    echo "Configuration de Redis pour WordPress..."
    
    # Installer le plugin Redis Object Cache
    wp plugin install redis-cache --activate --allow-root
    
    # Configurer Redis dans wp-config.php
    cat >> /var/www/html/wp-config.php << 'EOF'

/* Configuration Redis */
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_TIMEOUT', 1);
define('WP_REDIS_READ_TIMEOUT', 1);
define('WP_REDIS_DATABASE', 0);
EOF
    
    # Attendre que Redis soit disponible
    echo "Attente de la disponibilité de Redis..."
    while ! nc -z redis 6379 2>/dev/null; do
        echo "Redis n'est pas encore prêt, attente..."
        sleep 2
    done
    echo "Redis est disponible!"
    
    # Activer le cache Redis
    wp redis enable --allow-root
    
    echo "Redis configuré avec succès!"
    
    echo "WordPress installé avec succès!"
else
    echo "WordPress déjà installé"
fi

# Corriger les permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Créer le répertoire des sessions PHP
mkdir -p /var/lib/php/sessions
chown -R www-data:www-data /var/lib/php/sessions

echo "Démarrage de PHP-FPM..."
exec php-fpm7.4 -F
