#!/bin/bash

LOGDIR=/home/pi/logs
LOGFILE=$LOGDIR/pihole.log
TIMESTAMP=`date +%Y/%m/%d_%H:%M`

IPV6_ADDRESS=$(ip addr show dev eth0 | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d')
PIHOLE_IPV6=$(cat /etc/pihole/setupVars.conf | sed -e's/^.*IPV6_ADDRESS=\([^ ]*\)\/.*$/\1/;t;d')

if [ "$PIHOLE_IPV6" == "$IPV6_ADDRESS" ]
then
:
else
sudo sed -i.bak "/IPV6_ADDRESS/d;" "/etc/pihole/setupVars.conf"
echo "IPV6_ADDRESS=${IPV6_ADDRESS}/64" | sudo tee --append  "/etc/pihole/setupVars.conf"
echo "DONE"
fi

