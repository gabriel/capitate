#!/bin/sh

set -e

cd /tmp 

wget -nv http://www.danga.com/memcached/dist/memcached-1.2.4.tar.gz

tar zxpf memcached-1.2.4.tar.gz

cd memcached-1.2.4
./configure --prefix=/usr/local
make && make install

cd ..
rm -rf memcached-1.2.4*

