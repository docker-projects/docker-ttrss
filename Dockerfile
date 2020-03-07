########################
# Tiny Tiny RSS
# https://tt-rss.org/
# https://git.tt-rss.org/fox/tt-rss
########################
FROM alpine:3.10.2
MAINTAINER DevDotNet.Org <anton@devdotnet.org>
LABEL maintainer="DevDotNet.Org <anton@devdotnet.org>"

#Infrastructure layer - nginx,php

RUN apk update \
   && apk add --no-cache \
      bash \
	  sudo \
	  wget \
	  git \
	  nginx \
	  postgresql-dev \
      php7 \
      php7-apcu \
      php7-curl \
      php7-dom \
      php7-fileinfo \
      php7-fpm \
      php7-gd \
      php7-iconv \
      php7-intl \
      php7-json \
      php7-mbstring \
      php7-mysqli \
      php7-mysqlnd \
      php7-opcache \
      php7-pcntl \
	  php7-pdo \
      php7-pdo_mysql \
      php7-pdo_pgsql \
      php7-pgsql \
      php7-posix \
      php7-session \
      php7-zlib \
    && apk add --no-cache --virtual=build-dependencies \
      curl \
      tar \
    && mkdir /run/nginx \
    && curl -o /tmp/ttrss.tar.gz -L "https://git.tt-rss.org/git/tt-rss/archive/master.tar.gz" \
    && mkdir -p /usr/html/ \
    && tar xf /tmp/ttrss.tar.gz -C /usr/html/ --strip-components=1 \
    && rm -rf /tmp/ttrss.tar.gz \
    && apk del build-dependencies \
    && rm -rf /var/lib/{cache,log}/  \
    && rm -rf /var/lib/apt/lists/*.lz4  \
    && rm -rf /tmp/* /var/tmp/*  \
    && rm -rf /usr/share/doc/  \
    && rm -rf /usr/share/man/

#Configuration layer
	
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php7/php.ini && \
    sed -i 's/expose_php = On/expose_php = Off/g' /etc/php7/php.ini && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd && \
    sed -i "s/nginx:x:100:101:nginx:\/var\/lib\/nginx:\/sbin\/nologin/nginx:x:100:101:nginx:\/usr:\/bin\/bash/g" /etc/passwd- && \
    ln -s /sbin/php-fpm7 /sbin/php-fpm
	
ADD files/nginx.conf /etc/nginx/
ADD files/php-fpm.conf /etc/php7/
ADD files/start.sh /
ADD files/runupdaterss /etc/periodic/15min/runupdaterss
ADD files/robots.txt /usr/html/

RUN chmod +x /etc/periodic/15min/runupdaterss && chmod +x /start.sh

#Plugins layer
#ToDo

EXPOSE 80/tcp

VOLUME /usr/html/ 

CMD ["/start.sh"]
