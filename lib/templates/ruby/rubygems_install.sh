#! /bin/sh

set -e
trap error ERR

cd /tmp
wget -nv http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz
tar zxpf rubygems-1.0.1.tgz
cd rubygems-1.0.1
ruby setup.rb
cd ..
rm -rf rubygems*