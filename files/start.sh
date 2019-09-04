#!/bin/sh
echo "[Start start.sh]"

# Configuration file preparation
echo "Configuration file preparation"

#config.php in /usr/html
if [ -f /usr/html/config.php ]; then
	if [ ! -L /usr/html/config.php ]; then
	  #config.php is file in /usr/html
	  echo "config.php is file in /usr/html"
	  echo "config.php move to  /ttrss/config.php"
	  cp /usr/html/config.php /ttrss/config.php
	  rm /usr/html/config.php	  
	fi  
fi

#config.php in volume
if [ -f /ttrss/config.php ]; then
	echo "[i] Creating link to config.php"
    ln -s /ttrss/config.php /usr/html/config.php
fi

echo "[i] Fixing permissions..."
chown -R nginx:nginx /usr/html
chown -R nginx:www-data /usr/html

# start php-fpm
echo "start php-fpm"

mkdir -p /usr/logs/php-fpm
php-fpm7

# start cron
echo "start cron"

#/usr/sbin/crond -b
/usr/sbin/crond -b -l 0 -L /var/log/crond

# start nginx
echo "start nginx"

mkdir -p /usr/logs/nginx
mkdir -p /tmp/nginx
mkdir -p /tmp/nginx/body
mkdir -p /tmp/nginx/fastcgi_temp
mkdir -p /var/tmp/nginx/proxy
chown nginx /tmp/nginx
#
nginx
