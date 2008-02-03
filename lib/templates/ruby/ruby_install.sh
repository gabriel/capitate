#! /bin/sh

set -e

cd /usr/src
wget -nv ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.6-p110.tar.gz
tar xzf ruby-1.8.6-p110.tar.gz
cd ruby-1.8.6-p110
./configure --prefix=/usr
make && make install

# Fix openssl
cd /usr/src/ruby-1.8.6-p110/ext/openssl
ruby extconf.rb
make && make install

cd /usr/src
rm ruby-1.8.6-p110.tar.gz