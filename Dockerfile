FROM mysql:5.5

MAINTAINER michimau <mauro.michielon@eea.europa.eu>

#downgrading php to 5.3

RUN mv /etc/apt/sources.list /etc/apt/sources.list_bak

RUN echo deb http://ftp.us.debian.org/debian/ squeeze main contrib non-free > /etc/apt/sources.list
RUN echo deb-src http://ftp.us.debian.org/debian/ squeeze main contrib non-free >> /etc/apt/sources.list

RUN apt-get -y update && apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        apache2 \
        php5 \
        php5-mysql \
        libapache2-mod-php5 \
        php5-ldap \
        php5-xsl \
        nano \
        vim \
        zendframework

RUN mkdir /var/local/www-logs && mkdir /var/local/www-logs/iris2 && touch /var/local/www-logs/iris2/access
COPY default /etc/apache2/sites-available/default
COPY ./my.cnf /etc/mysql/my.cnf 

RUN a2enmod php5 ldap rewrite

RUN mkdir /run/mysqld && chmod 777 /run/mysqld 

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY ./my.cnf /etc/mysql/my.cnf

EXPOSE 80

CMD apachectl start && mysqld
