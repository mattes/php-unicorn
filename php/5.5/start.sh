#!/usr/bin/env bash

# update IP redirecting
# 127.0.0.1:3306 -> DB:3306
if [[ $DB_PORT_3306_TCP_ADDR && $DB_PORT_3306_TCP_PORT ]]; then
  echo "127.0.0.1 3306 $DB_PORT_3306_TCP_ADDR $DB_PORT_3306_TCP_PORT" >> /etc/rinetd.conf
  /etc/init.d/rinetd restart
else
  /etc/init.d/rinetd stop
fi


php5-fpm