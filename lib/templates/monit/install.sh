#! /bin/sh

set -e

cd /tmp 

wget -nv http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz

tar zxpf monit-4.10.1.tar.gz

cd monit-4.10.1
./configure
make
make install

cd ..
rm -rf monit-4.10.1*