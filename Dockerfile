FROM php:7.3.3-apache
RUN apt-get update && apt-get upgrade -y
RUN docker-php-ext-install pdo_mysql \
	mysqli
RUN a2enmod rewrite
COPY . /var/www/html/
RUN chmod -R 755 /var/www/html/
EXPOSE 80
EXPOSE 3306