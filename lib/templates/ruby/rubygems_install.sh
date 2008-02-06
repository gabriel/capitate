#! /bin/sh

set -e
trap ERROR ERR

cd /tmp
wget -nv http://rubyforge.org/frs/download.php/29548/rubygems-1.0.1.tgz
tar zxpf rubygems-1.0.1.tgz
cd rubygems-1.0.1
echo "Installing rubygems..."
ruby setup.rb > ruby_setup.log
cd ..
rm -rf rubygems*