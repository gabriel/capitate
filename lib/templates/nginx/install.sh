#! /bin/bash

install -o root /tmp/nginx /etc/init.d/nginx
/sbin/chkconfig --level 345 nginx on
   
install -o root -m 644 /tmp/nginx.conf /usr/local/nginx/nginx.conf

id nginx || /usr/sbin/adduser -r nginx