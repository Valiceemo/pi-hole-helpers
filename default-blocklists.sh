#!/bin/bash

today=$(date +%Y%m%d_%H%M%S)
timestamp=$(date +%Y/%m/%d_%H:%M:%S)
LogFile=/home/pi/logs/pihole.log
PiholeDir=/etc/pihole
TICK="[\e[32m✓\e[0m]"
INFO="[i]"
QUES="[?]"

clear

sleep 0.5

echo -e " \e[32m This script will return Pi-Hole blocked domains to the default \e[0m"
sleep 2

## Backup exisiting adlists.list file
str="Backing up existing..."
echo -n " ${INFO} ${str}"
sudo cp /etc/pihole/adlists.list /etc/pihole/adlists.list.bk.$today
sleep 1
echo -e "\\r ${TICK} ${str}"
sleep 1

# Remove existing adlists.list
str="Removing current adlists.list"
echo -n " ${INFO} ${str}..."
sudo rm /etc/pihole/adlists.list
sleep 3
echo -e "\\r ${TICK} ${str}..."

# Add default adlists
str="Restoring default adlists..."
echo -n " ${INFO} ${str}"
# add them here.....

echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" | sudo tee /etc/pihole/adlists.list >/dev/null 2>&1
echo "https://mirror1.malwaredomains.com/files/justdomains" | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
echo "http://sysctl.org/cameleon/hosts" | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
echo "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist" | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
echo "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt" | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
echo "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt" - sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
echo "https://hosts-file.net/ad_servers.txt" | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
sleep 0.5
echo -e "\\r ${TICK} ${str}"

# Run gravity if user chooses
echo -n " ${INFO} In order to apply the new adlists, you must run Pi-Hope Gravity"

echo -e " ${QUES} Do you wish to run gravity now?"

read -n 1 -r -p " ${QUES} Select Yes or No"
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -n " ${INFO} Starting gravity..."
	sleep 1
	echo -e "\\r ${TICK} Gravity is running, please be patient..."
	sudo bash /etc/.pihole/gravity.sh >/dev/null 2>&1
	echo -e "\\r ${TICK} Gravity is done"

else
	echo -n " ${INFO} Gravity must he run manually to see changes!"
	echo
	exit 1

fi

echo -e " ${TICK} All Done. Pi-Hole default adlists restored"
