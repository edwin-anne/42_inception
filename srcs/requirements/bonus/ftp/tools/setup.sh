#!/bin/bash

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Initialisation du serveur FTP...${NC}"

# Création de l'utilisateur FTP si les variables d'environnement sont définies
if [ ! -z "$FTP_USER" ] && [ ! -z "$FTP_PASSWORD" ]; then
    echo -e "${YELLOW}Création de l'utilisateur FTP: $FTP_USER${NC}"
    
    # Créer l'utilisateur avec le répertoire home pointant vers WordPress
    useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"
    
    # Définir le mot de passe
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    
    # Ajouter l'utilisateur à la liste des utilisateurs autorisés
    echo "$FTP_USER" > /etc/vsftpd.userlist
    
    # Changer le propriétaire du répertoire WordPress
    chown -R "$FTP_USER:$FTP_USER" /var/www/html
    
    echo -e "${GREEN}Utilisateur FTP $FTP_USER créé avec succès${NC}"
else
    echo -e "${RED}Variables FTP_USER et FTP_PASSWORD non définies${NC}"
    echo -e "${YELLOW}Création d'un utilisateur par défaut...${NC}"
    
    # Utilisateur par défaut
    useradd -m -d /var/www/html -s /bin/bash "ftpuser"
    echo "ftpuser:ftppass" | chpasswd
    echo "ftpuser" > /etc/vsftpd.userlist
    chown -R ftpuser:ftpuser /var/www/html
    
    echo -e "${GREEN}Utilisateur par défaut créé: ftpuser/ftppass${NC}"
fi

# Créer le répertoire de logs
mkdir -p /var/log

# Vérifier que le répertoire WordPress existe
if [ ! -d "/var/www/html" ]; then
    echo -e "${YELLOW}Création du répertoire /var/www/html${NC}"
    mkdir -p /var/www/html
fi

# Définir les permissions appropriées
chmod 755 /var/www/html

echo -e "${GREEN}Configuration terminée. Démarrage de vsftpd...${NC}"

# Démarrer vsftpd en mode foreground
exec /usr/sbin/vsftpd /etc/vsftpd.conf
