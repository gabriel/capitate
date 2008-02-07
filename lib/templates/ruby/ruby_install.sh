#! /bin/sh

set -e
trap ERROR ERR

cd /usr/src
wget -nv http://capigen.s3.amazonaws.com/ruby-1.8.6-p110.tar.gz
# ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.6-p110.tar.gz
tar xzf ruby-1.8.6-p110.tar.gz
cd ruby-1.8.6-p110
echo "Configuring ruby..."
./configure --prefix=/usr > configure.log
echo "Compiling ruby..."
make > make.log
echo "Installing ruby..."
make install > make_install.log

# Fix openssl
cd /usr/src/ruby-1.8.6-p110/ext/openssl
echo "Fix for ruby openssl..."
ruby extconf.rb > extconf.log
make clean > make.log
make >> make.log
make install >>  make.log

cd /usr/src
rm ruby-1.8.6-p110.tar.gz