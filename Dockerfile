FROM php:8.1-apache
COPY . /var/www/html
RUN sed -i "s/\$dbPassword = \".*\";/\$dbPassword = \"codepass\";/" /var/www/html/config.php && \
docker-php-ext-install mysqli && \
docker-php-ext-enable mysqli
EXPOSE 80