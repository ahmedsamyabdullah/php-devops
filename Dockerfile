FROM php:8.4-apache-alpine
RUN apt-get update && apt-get upgrade -y && apt-get clean
# Copy app files to the container
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html

# Expose Apache port
EXPOSE 80
