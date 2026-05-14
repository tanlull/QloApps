FROM php:8.2-apache

# Install required system packages for QloApps
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Configure and install required PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql soap zip xml dom

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure Apache DocumentRoot if needed (default is /var/www/html)
WORKDIR /var/www/html

# Permissions (will be applied to volumes at runtime but good practice)
RUN chown -R www-data:www-data /var/www/html

# Custom PHP settings for QloApps
RUN echo "upload_max_filesize = 32M\npost_max_size = 32M" > /usr/local/etc/php/conf.d/uploads.ini
