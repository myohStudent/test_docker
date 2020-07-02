FROM debian:buster

# UPDATE & INSTALL
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install nginx mariadb-server
RUN apt-get -y install php php-fpm php-curl php-mysql php-mbstring 
RUN apt-get -y install vim

# COPY FILES
COPY ./srcs/admin.crt .
COPY ./srcs/admin.key .
RUN mkdir ssl
RUN mv admin.crt ./ssl
RUN mv admin.key ./ssl 
COPY ./srcs/default ./etc/nginx/sites-available/default
COPY ./srcs/wp-config.php ./var/www/html/wordpress/wp-config.php
COPY ./srcs/config.inc.php ./var/www/html/phpmyadmin/config.inc.php
COPY ./srcs/phpMyAdmin.tar.gz .
COPY ./srcs/wordpress.tar.gz .
COPY ./srcs/init.sh .

# PHPMYADMIN & WORDPRESS
RUN tar -xvf phpMyAdmin.tar.gz --strip-components 1 -C ./var/www/html/phpmyadmin
RUN tar -xvf wordpress.tar.gz --strip-components 1 -C /var/www/html/wordpress

# ACCESSF PERMISSION 
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

# MYSQL & BASH
CMD service mysql start && mysql --execute "CREATE USER 'admin'@'localhost' IDENTIFIED BY '1234'; CREATE DATABASE ft_server; GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost'; FLUSH PRIVILEGES;";\
	bash init.sh
