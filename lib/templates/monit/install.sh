#! /bin/sh

cd /tmp 
tar zxpf monit-4.10.1.tar.gz

cd monit-4.10.1
./configure
make
make install

cd ..
rm -rf monit-4.10.1*