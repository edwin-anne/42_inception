FROM debian:bullseye

# Installation de vsftpd et des outils nécessaires
RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

# Création du répertoire de configuration
RUN mkdir -p /var/run/vsftpd/empty

# Copie du fichier de configuration
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Copie du script d'initialisation
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Exposition du port FTP et des ports passifs
EXPOSE 21 21000-21010

# Commande de démarrage
CMD ["/usr/local/bin/setup.sh"]
