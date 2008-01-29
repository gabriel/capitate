#! /bin/sh

set -e
trap error ERR

cd /usr/src
wget -nv ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.6-p110.tar.gz
tar xzf ruby-1.8.6-p110.tar.gz
cd ruby-1.8.6-p110
./configure --prefix=/usr
make && make install
cd ../
rm ruby-1.8.6-p110.tar.gz