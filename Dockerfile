# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: egomes <egomes@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/05/10 21:25:40 by egomes            #+#    #+#              #
#    Updated: 2021/05/10 21:36:46 by egomes           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get -y update                       
RUN apt-get -y install nginx \                        
   mariadb-server \                        
   php-fpm php-mysql \                        
   wget dialog apt-utils \                        
   php php-cgi php-mysqli php-pear php-mbstring php-gettext php-common php-phpseclib php-mysql

WORKDIR /var/www/localhost

COPY srcs/nginx.config /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/nginx.config /etc/nginx/sites-enabled/

COPY ./srcs/config.inc.php /var/www/myserver/phpmyadmin/
COPY ./srcs/wp-config.php /var/www/myserver/wordpress/

RUN chown -R www-data:www-data ../**/**                       
RUN chown -R 755 /var/www/myserver                       
RUN chmod -R 755 /var/www/*

RUN openssl req -x509 -nodes -days 365 -subj "/C=PT/ST=PORTUGAL/L=LISBON/O=42/OU=CLAUSTERONE/CN=EGOMES" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

COPY ./srcs/init.sh ./                       
CMD /bin/bash ./init.sh
EXPOSE 80 443