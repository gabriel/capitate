#! /bin/bash

set -e
trap error ERR

cd /tmp/nginx

wget -nv http://sysoev.ru/nginx/nginx-0.5.35.tar.gz

tar zxpf nginx-0.5.35.tar.gz

cd nginx-0.5.35
./configure --sbin-path=/sbin/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-md5=auto/lib/md5 --with-sha1=auto/lib/sha1 --with-http_ssl_module
make
make install

cd ..
rm -rf nginx-0.5.35*

install -o root nginx.initd /etc/init.d/nginx
/sbin/chkconfig --level 345 nginx on
   
install -o root -m 644 nginx.conf /usr/local/nginx/nginx.conf

id nginx || /usr/sbin/adduser -r nginx