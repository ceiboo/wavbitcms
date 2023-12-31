#FROM elmarit/harbour:3.4 as builder
#WORKDIR /app
#COPY ./harbour/src/ /app/
#RUN hbmk2 -fullstatic cms.hbp cms.hbc -ocms 


FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    autoconf automake make gcc g++ \
    librabbitmq-dev \
    libonig-dev \
    libxml2-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    zip \
    unzip \
    libzip-dev    

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure bcmath --enable-bcmath \
  && docker-php-ext-configure pcntl --enable-pcntl

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath intl
RUN docker-php-ext-install mysqli

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN mkdir -p /home/$user

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer

# Set working directory
WORKDIR /home/$user/


#COPY ./harbour/src/ /home/$user/app/
#COPY --from=builder /app/ /home/$user/app/

CMD ["./app/cms"]

USER $user