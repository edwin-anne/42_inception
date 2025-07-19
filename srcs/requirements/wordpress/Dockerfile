FROM debian:bullseye

# Mise à jour des packages et installation de PHP-FPM et extensions nécessaires
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-curl \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    php7.4-intl \
    php7.4-json \
    php7.4-imagick \
    php7.4-opcache \
    php7.4-redis \
    curl \
    wget \
    unzip \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Création des répertoires nécessaires
RUN mkdir -p /var/www/html \
    && mkdir -p /var/run/php \
    && mkdir -p /var/log/php

# Copie des fichiers de configuration
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY conf/php.ini /etc/php/7.4/fpm/php.ini

# Copie du script d'initialisation
COPY tools/init.sh /usr/local/bin/init.sh
COPY tools/wp-config.php /usr/local/bin/wp-config.php
# Rendre les scripts exécutables
RUN chmod +x /usr/local/bin/init.sh

# Changement des permissions
RUN chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/run/php \
    && chown -R www-data:www-data /var/log/php

# Exposition du port 9000 pour PHP-FPM
EXPOSE 9000

# Utilisation du script d'initialisation
CMD ["/usr/local/bin/init.sh"]
