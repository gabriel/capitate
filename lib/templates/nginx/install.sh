#! /bin/bash

cd /tmp 
tar zxpf nginx-0.5.35.tgz

cd nginx-0.5.35
./configure --sbin-path=/sbin/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-md5=auto/lib/md5 --with-sha1=auto/lib/sha1 --with-http_ssl_module
make
make install

cd ..
rm -rf nginx-0.5.35*

install -o root /tmp/nginx /etc/init.d/nginx
/sbin/chkconfig --level 345 nginx on
   
install -o root -m 644 /tmp/nginx.conf /usr/local/nginx/nginx.conf

id nginx || /usr/sbin/adduser -r nginx