#! /bin/sh

set -e
trap ERROR ERR

cd /tmp 

wget -nv http://www.tildeslash.com/monit/dist/monit-4.10.1.tar.gz

tar zxpf monit-4.10.1.tar.gz

cd monit-4.10.1
echo "Configuring monit..."
./configure > configure.log
echo "Compiling monit..."
make > make.log
echo "Installing monit..."
make install > make_install.log

cd ..
rm -rf monit-4.10.1*

mkdir -p /etc/monit

install -o root -m 700 /tmp/monitrc /etc/monitrc 
rm -f /tmp/monitrc

install -o root /tmp/monit.initd /etc/init.d/monit 
rm -f /tmp/monit.initd