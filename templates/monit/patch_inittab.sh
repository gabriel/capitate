#! /bin/sh

set -e
trap ERROR ERR

NO_MONIT=0
grep -q monit /etc/inittab > /dev/null || export NO_MONIT=1

if [ $NO_MONIT == 1 ]; then
  echo "Patching inittab with monit..."
  echo "" >> /etc/inittab
  echo "# Run monit in standard run-levels" >> /etc/inittab
  echo "mo:345:respawn:/usr/local/bin/monit -Ic /etc/monitrc -l /var/log/monit.log -p /var/run/monit.pid" >> /etc/inittab
  telinit q
fi