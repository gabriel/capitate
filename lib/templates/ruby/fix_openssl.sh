#! /bin/sh

set -e
trap ERROR ERR

# Fix openssl
cd /usr/src/ruby-1.8.6-p110/ext/openssl
echo "Fix for ruby openssl..."
ruby extconf.rb > extconf.log
make clean > make.log
make >> make.log
make install >>  make.log