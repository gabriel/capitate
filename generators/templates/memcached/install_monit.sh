#!/bin/sh

install -o root /tmp/memcached.monitrc /etc/monit/memcached.monitrc
rm -f /tmp/memcached.monitrc