#!/bin/sh

set -e
trap ERROR ERR

# Add admin group
cat /etc/group | grep admin || /usr/sbin/groupadd admin

# Install sudoers
install -o root -m 440 /tmp/sudoers /etc/sudoers
rm -f /tmp/sudoers

# Change inittab to runlevel 3
sed -i -e 's/^id:5:initdefault:/id:3:initdefault:/g' /etc/inittab

# Create web apps directory
mkdir -p /var/www/apps
