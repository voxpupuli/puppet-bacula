#!/bin/sh

test $# -gt 0 || exit 1

/sbin/service mysql stop

/usr/sbin/mysqld --skip-grant-tables --user=root --datadir=/var/lib/mysql &
sleep 5
echo "USE mysql; UPDATE user SET Password=PASSWORD('$1') WHERE User='root' AND Host='localhost';" | mysql -u root
killall mysqld

/sbin/service mysqld start

