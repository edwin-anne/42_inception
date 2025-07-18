#!/bin/bash

# Script d'initialisation pour nginx

# Vérifier si les certificats SSL existent
if [ ! -f /etc/nginx/ssl/nginx.crt ] || [ ! -f /etc/nginx/ssl/nginx.key ]; then
    echo "Génération des certificats SSL..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=localhost"
fi

# Vérifier la configuration nginx
nginx -t

# Démarrer nginx
exec nginx -g "daemon off;"
