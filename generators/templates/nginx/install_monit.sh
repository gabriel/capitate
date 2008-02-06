#! /bin/sh

set -e
trap ERROR ERR

mkdir -p /etc/monit 
install -o root /tmp/nginx.monitrc /etc/monit/nginx.monitrc 
rm -f /tmp/nginx.monitrc