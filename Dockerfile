FROM php:7.0-apache
RUN apt-get update -y
RUN apt-get install -y \
	libcurl4-openssl-dev libmcrypt-dev libzip-dev libxml2-dev libjpeg-dev libxpm-dev \
	libxslt-dev libpq-dev sqlite3 libsqlite3-dev libbz2-dev libpng-dev libfreetype6-dev \
	libc-client2007e-dev libicu-dev git ssh subversion sudo reprepro git libmemcached-dev libmemcached11

RUN docker-php-ext-install \
	pdo_mysql curl iconv mbstring mcrypt sockets soap simplexml
RUN docker-php-ext-install \
	zip pdo_sqlite pdo_pgsql dom bcmath mcrypt
RUN docker-php-ext-install \
	mysqli pcntl pdo bz2 exif fileinfo ftp intl json
RUN docker-php-ext-configure gd --with-png-dir=/usr/lib --with-jpeg-dir=/usr/lib --with-freetype-dir
RUN docker-php-ext-install gd

RUN a2enmod rewrite
WORKDIR /tmp/
RUN git clone https://github.com/php-memcached-dev/php-memcached
WORKDIR /tmp/php-memcached
RUN git checkout -b php7 origin/php7
RUN phpize
RUN ./configure
RUN make
RUN make install
RUN echo "extension=memcached.so" > "/usr/local/etc/php/conf.d/memcached.ini"
WORKDIR /home/
RUN rm -Rf /tmp/php-memcached
ADD site.conf /etc/apache2/sites-enabled/000-default.conf
VOLUME ["/var/log/apache2/", "/var/www/html/"]
EXPOSE 80
