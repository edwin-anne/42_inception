FROM debian:bullseye

# Mise à jour des packages et installation de MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Création des répertoires nécessaires
RUN mkdir -p /var/run/mysqld \
    && mkdir -p /var/lib/mysql \
    && mkdir -p /etc/mysql/conf.d

# Copie du fichier de configuration MariaDB
COPY conf/my.cnf /etc/mysql/conf.d/my.cnf

# Copie du script d'initialisation
COPY tools/init.sh /usr/local/bin/init.sh

# Rendre les scripts exécutables
RUN chmod +x /usr/local/bin/init.sh

# Changement des permissions pour mysql
RUN chown -R mysql:mysql /var/lib/mysql \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 755 /var/lib/mysql \
    && chmod 755 /var/run/mysqld

# Exposition du port 3306 pour MySQL
EXPOSE 3306

# Utilisation du script d'initialisation
CMD ["/usr/local/bin/init.sh"]
