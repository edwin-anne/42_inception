#!/bin/bash

# Script d'initialisation pour MariaDB

set -e

echo "=== Démarrage du script d'initialisation MariaDB ==="

# Vérifier les variables d'environnement requises
if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "Erreur: Variables d'environnement manquantes"
    echo "Requis: MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD"
    exit 1
fi

# Vérifier et créer les répertoires nécessaires
echo "Vérification des répertoires..."
mkdir -p /var/lib/mysql
mkdir -p /var/run/mysqld
mkdir -p /var/log/mysql

# Corriger les permissions
echo "Correction des permissions..."
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/log/mysql
chmod 755 /var/lib/mysql
chmod 755 /var/run/mysqld

# Vérifier si MariaDB est déjà initialisée
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de MariaDB..."
    
    # Initialiser la base de données
    echo "Installation de la base de données..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm --skip-name-resolve --force
    
    # Démarrer MariaDB temporairement
    echo "Démarrage temporaire de MariaDB..."
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-grant-tables --skip-networking --socket=/var/run/mysqld/mysqld.sock &
    MYSQL_TEMP_PID=$!
    
    # Attendre que MariaDB soit prêt
    echo "Attente du démarrage de MariaDB..."
    for i in {1..60}; do
        if mysqladmin ping --socket=/var/run/mysqld/mysqld.sock --silent 2>/dev/null; then
            echo "MariaDB est prêt!"
            break
        fi
        if [ $i -eq 60 ]; then
            echo "Erreur: Timeout - MariaDB n'a pas démarré"
            kill $MYSQL_TEMP_PID 2>/dev/null
            exit 1
        fi
        echo "Tentative $i/60..."
        sleep 1
    done
    
    # Configuration initiale de sécurité
    echo "Configuration de la sécurité..."
    mysql --socket=/var/run/mysqld/mysqld.sock <<EOF
FLUSH PRIVILEGES;
UPDATE mysql.user SET Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF
    
    # Création de la base de données WordPress
    echo "Création de la base de données WordPress..."
    mysql --socket=/var/run/mysqld/mysqld.sock -u root -p${MYSQL_ROOT_PASSWORD} <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    
    # Arrêter MariaDB temporaire proprement
    echo "Arrêt de MariaDB temporaire..."
    mysqladmin --socket=/var/run/mysqld/mysqld.sock -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    
    # Attendre que le processus se termine
    echo "Attente de l'arrêt complet..."
    wait $MYSQL_TEMP_PID 2>/dev/null || true
    
    echo "MariaDB initialisée avec succès!"
else
    echo "MariaDB déjà initialisée"
fi

# Corriger les permissions avant le démarrage final
echo "Correction finale des permissions..."
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld

# Démarrer MariaDB de manière permanente
echo "Démarrage permanent de MariaDB..."
echo "Vérification finale des permissions..."
ls -la /var/lib/mysql/
ls -la /var/run/mysqld/

echo "Démarrage de MariaDB avec les paramètres suivants:"
echo "- User: mysql"
echo "- Datadir: /var/lib/mysql"
echo "- Socket: /var/run/mysqld/mysqld.sock"
echo "- Config: /etc/mysql/my.cnf"

# Vérifier la configuration
if [ -f "/etc/mysql/my.cnf" ]; then
    echo "Fichier de configuration trouvé"
else
    echo "Attention: Fichier de configuration manquant"
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=/var/run/mysqld/mysqld.sock --bind-address=0.0.0.0
