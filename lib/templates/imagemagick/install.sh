#! /bin/sh

set -e
trap ERROR ERR

cd /tmp

wget -nv ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz

tar zxpf ImageMagick.tar.gz
cd ImageMagick-*
echo "Configuring ImageMagick..."
./configure > configure.log
echo "Compiling ImageMagick..."
make > make.log
echo "Installing ImageMagick..."
make install > make_install.log

cd ..
rm -rf ImageMagick*