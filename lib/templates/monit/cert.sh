#! /bin/sh

set -e

openssl req -new -x509 -days 365 -nodes -config /var/certs/monit.cnf -out /var/certs/monit.pem -keyout /var/certs/monit.pem -batch
openssl gendh 512 >> /var/certs/monit.pem
openssl x509 -subject -dates -fingerprint -noout -in /var/certs/monit.pem
chmod 700 /var/certs/monit.pem