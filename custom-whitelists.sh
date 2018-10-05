#!/bin/bash
# This script will download and add domains to your Pi-Hole Whitelist
# Project homepage: 
# Licence: 
# Created by Valiceemo
#================================================================================

VERSION = 001

TICK="[\e[32m ✓ \e[0m]"
INFO="[ i ]"

clear
sleep 0.55
echo -e " \e[1m This script will download and add commonly listed domains to whitelist.txt \e[0m"
sleep 1
echo -e "\n"

## CHECK FOR ROOT 

if [ "$(id -u)" != "0" ] ; then
  echo "This script requires root permissions. Please run this as root!"
  exit 2
fi

## CHECK IF GAWK INSTALLED, IF NOT INSTALL
if [ "$(dpkg-query -W -f='${Status}' gawk 2>/dev/null |  grep -c "ok installed")" -eq 0 ];
then
  echo -e " [...] \e[32m Installing gawk... \e[0m"
  apt-get install gawk -qq > /dev/null
  wait
  echo -e " ${TICK} \e[32m Finished \e[0m"
fi

### CHECK FOR /etc/pihole/whitelist.txt

echo -e " ${INFO} \e[32m Checking if whitelist.txt already exists \e[0m"
if [ -f /etc/pihole/whitelist.txt ]
then
  echo -e " ${INFO} \e[32m Backing up whitelist.txt... \e[0m"
  cp /etc/pihole/whitelist.txt /etc/pihole/whitelist.txt.orig
  echo -e " ${TICK} \e[32m Backup made to /etc/pihole/whitelist.txt.orig  \e[0m"
else
  echo -e " ${INFO} \e[32m No whitelist file exists \e[0m"
fi

sleep 0.5

#curl -sS https://raw.githubusercontent.com/Valiceemo/pi-setup/master/PiHole/valiceemo-whitelist.txt | sudo tee -a /etc/pihole/whitelist.txt >/dev/null
echo -e " ${TICK} \e[32m Adding to whitelist... \e[0m"
sleep 0.5
echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
sudo gawk -i inplace '!a[$0]++' /etc/pihole/whitelist.txt
wait
echo -e " ${INFO} \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
pihole -g > /dev/null

wait

echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
echo -e " ${TICK} \e[32m Done! \e[0m"
echo -e " \e[1m  All Done!\e[0m"
echo -e "\n\n"
