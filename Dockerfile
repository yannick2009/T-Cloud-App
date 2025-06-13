# Utilisez une image Docker officielle pour PHP 7.4 avec Apache
FROM php:7.4-apache

# Installer dépendances système et PHP
RUN apt-get update && apt-get install -y git unzip p7zip-full \
    && docker-php-ext-install pdo_mysql

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier les fichiers nécessaires pour installer les dépendances
COPY composer.json composer.lock ./

# Installer les dépendances PHP via Composer
RUN composer install --no-dev --no-scripts --prefer-dist --no-interaction

# Copier le reste des fichiers
COPY . .

COPY entrypoint.sh /entrypoint.sh

# Fixer les permissions recommandées
RUN chown -R www-data:www-data . \
    && chmod -R 775 storage bootstrap/cache

# Configurer Apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Activer le module de réécriture d'URL d'Apache
RUN a2enmod rewrite

#
RUN chmod +x /entrypoint.sh

# Exposer le port 80 pour le serveur web
EXPOSE 80

ENTRYPOINT ["./entrypoint.sh"]
