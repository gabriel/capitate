#! /bin/sh

set -e
trap ERROR ERR

mkdir -p /var/certs
mv /tmp/monit.cnf /var/certs/monit.cnf

echo "Generating PEM..."
openssl req -new -x509 -days 365 -nodes -config /var/certs/monit.cnf -out /var/certs/monit.pem -keyout /var/certs/monit.pem -batch > /var/certs/debug_req.log
openssl gendh 512 >> /var/certs/monit.pem 2> /var/certs/debug_gendh.log
echo "Generating x509..."
openssl x509 -subject -dates -fingerprint -noout -in /var/certs/monit.pem > /var/certs/debug_x509.log
chmod 700 /var/certs/monit.pem