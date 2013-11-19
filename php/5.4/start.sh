#!/usr/bin/env bash

# update IP redirecting
# 127.0.0.1:3306 -> DB:3306
cp -f /etc/rinetd.conf.tpl /etc/rinetd.conf
sed -i -e "s/%{DB_TCP_ADDR}/$DB_PORT_3306_TCP_ADDR/" /etc/rinetd.conf
sed -i -e "s/%{DB_TCP_PORT}/$DB_PORT_3306_TCP_PORT/" /etc/rinetd.conf
/etc/init.d/rinetd restart

# start php fpm
php5-fpm