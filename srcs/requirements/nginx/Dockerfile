FROM debian:bullseye

# Mise à jour des packages et installation de nginx et openssl
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Création des répertoires nécessaires
RUN mkdir -p /etc/nginx/ssl \
    && mkdir -p /var/www/html \
    && mkdir -p /var/log/nginx \
    && mkdir -p /etc/nginx/conf.d

# Copie du fichier de configuration nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/fastcgi-php.conf /etc/nginx/conf.d/fastcgi-php.conf

# Copie du script d'initialisation
COPY tools/init.sh /usr/local/bin/init.sh

# Rendre le script exécutable
RUN chmod +x /usr/local/bin/init.sh

# Changement des permissions pour nginx
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Exposition du port 443 pour HTTPS
EXPOSE 443

# Utilisation du script d'initialisation
CMD ["/usr/local/bin/init.sh"]
