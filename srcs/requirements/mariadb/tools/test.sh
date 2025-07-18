#!/bin/bash

# Script de test pour MariaDB

echo "Test de connectivité MariaDB..."

# Vérifier si MariaDB répond
if mysqladmin ping --silent; then
    echo "✓ MariaDB répond"
else
    echo "✗ MariaDB ne répond pas"
    exit 1
fi

# Vérifier la base de données WordPress
if mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "USE ${MYSQL_DATABASE}; SELECT 1;" > /dev/null 2>&1; then
    echo "✓ Base de données WordPress accessible"
else
    echo "✗ Problème d'accès à la base de données WordPress"
    exit 1
fi

# Afficher les bases de données
echo "Bases de données disponibles:"
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW DATABASES;"

echo "Test terminé avec succès!"
