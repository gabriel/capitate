#!/bin/sh

set -e

# Create web apps directory
mkdir -p /var/www/apps

# Add admin group
cat /etc/group | grep admin || /usr/sbin/groupadd admin

# Install sudoers
install -o root -m 440 /tmp/sudoers /etc/sudoers

# Change inittab to runlevel 3
sed -i -e 's/^id:5:initdefault:/id:3:initdefault:/g' /etc/inittab