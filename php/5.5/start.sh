#!/usr/bin/env bash

# update IP redirecting
# 127.0.0.1:3306 -> DB:3306
if [[ $DB_PORT_3306_TCP_ADDR && $DB_PORT_3306_TCP_PORT ]]; then
  echo "127.0.0.1 3306 $DB_PORT_3306_TCP_ADDR $DB_PORT_3306_TCP_PORT" >> /etc/rinetd.conf
  echo "Redirect 127.0.0.1 3306 to $DB_PORT_3306_TCP_ADDR $DB_PORT_3306_TCP_PORT"
fi
if [[ $DB_1_PORT_3306_TCP_ADDR && $DB_1_PORT_3306_TCP_PORT ]]; then
  # fig support
  echo "127.0.0.1 3306 $DB_1_PORT_3306_TCP_ADDR $DB_1_PORT_3306_TCP_PORT" >> /etc/rinetd.conf
  echo "Redirect 127.0.0.1 3306 to $DB_1_PORT_3306_TCP_ADDR $DB_1_PORT_3306_TCP_PORT"
fi

# 127.0.0.1:21 -> FTP:21
if [[ $FTP_PORT_21_TCP_ADDR && $FTP_PORT_21_TCP_PORT ]]; then
  echo "127.0.0.1 21 $FTP_PORT_21_TCP_ADDR $FTP_PORT_21_TCP_PORT" >> /etc/rinetd.conf
  echo "Redirect 127.0.0.1 21 to $FTP_PORT_21_TCP_ADDR $FTP_PORT_21_TCP_PORT"
fi
if [[ $FTP_1_PORT_21_TCP_ADDR && $FTP_1_PORT_21_TCP_PORT ]]; then
  # fig support
  echo "127.0.0.1 21 $FTP_1_PORT_21_TCP_ADDR $FTP_1_PORT_21_TCP_PORT" >> /etc/rinetd.conf
  echo "Redirect 127.0.0.1 21 to $FTP_1_PORT_21_TCP_ADDR $FTP_1_PORT_21_TCP_PORT"
fi

/etc/init.d/rinetd restart
php5-fpm