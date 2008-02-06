#!/bin/sh

set -e
trap ERROR ERR


install -o root /tmp/mysql.monitrc /etc/monit/mysql.monitrc 
rm -f /tmp/mysql.monitrc