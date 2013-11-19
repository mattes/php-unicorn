FROM tianon/debian:jessie
MAINTAINER Matthias Kadenbach <matthias.kadenbach@gmail.com>

RUN apt-get update
RUN apt-get --force-yes -y install php5-fpm php5-mysql

RUN mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.backup
ADD php-fpm-www.conf /etc/php5/fpm/pool.d/www.conf

RUN sed -i -e 's/;daemonize = yes/daemonize = no/' /etc/php5/fpm/php-fpm.conf

# bind volumes
VOLUME ["/www"]

# expose ports
EXPOSE 20055

# run command
CMD ["php5-fpm"]
