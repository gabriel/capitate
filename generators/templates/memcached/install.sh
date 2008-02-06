#!/bin/sh

set -e
trap ERROR ERR

cd /tmp 

wget -nv http://www.danga.com/memcached/dist/memcached-1.2.4.tar.gz

tar zxpf memcached-1.2.4.tar.gz

cd memcached-1.2.4
echo "Configuring memcached..."
./configure --prefix=/usr/local > configure.log
echo "Compiling memcached..."
make > make.log
echo "Installing memcached..."
make install > make_install.log

cd ..
rm -rf memcached-1.2.4*

install -o root /tmp/memcached.initd /etc/init.d/memcached
rm -f /tmp/memcached.initd
/sbin/chkconfig --level 345 memcached on


