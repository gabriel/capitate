#!/bin/sh

cd /tmp 
tar zxpf sphinx-0.9.7.tar.gz

cd sphinx-0.9.7
./configure --with-mysql-includes=/usr/include/mysql --with-mysql-libs=/usr/lib/mysql --prefix=/usr/local/sphinx
make
make install

cd ..
rm -rf sphinx-0.9.7*

