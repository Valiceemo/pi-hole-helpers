#!/bin/bash
# This script will download the latest root.hints file from
# https://www.internic.net/domain/named.root
# Project homepage:
# Licence:
# Created by Valiceemo
#================================================================================

VERSION="003"

TICK="[\e[32m ✓ \e[0m]"
INFO="[ i ]"
CROSS="[\e[31m x \e[0m]"
AVAILABLE=`curl -s https://www.internic.net/domain/named.root | grep version | cut -d ':' -f 2 | tr -d ' '`

clear
sleep 1.0

echo " "
echo -e "\e[1m This script will download the latest root.hints file for unbound \e[0m"
sleep 0.5
echo " "

## CHECK FOR ROOT

if [ "$(id -u)" != "0" ] ; then
#  echo " "
  echo -e " ${CROSS} \e[31m This script requires root permissions. Please run this as root! \e[0m"
  echo " "
  exit 2
fi

# CHECK EXISTING ROOT.HINTS

echo -e " ${INFO} \e[37m Checking existing root.hints file at... \e[0m"

sleep 0.5

if [ -f /var/lib/unbound/root.hints ]; then
  echo -e " ${TICK} \e[32m Found file... \e[0m"
  INSTALLED=`cat /var/lib/unbound/root.hints | grep version | cut -d ':' -f 2 | tr -d ' '`
  mod=`stat -c %y /var/lib/unbound/root.hints | cut -d' ' -f1`
    if [ "$INSTALLED" = "$AVAILABLE" ]; then
      echo -e " ${INFO} \e[37m The Root hints file you have is the most recent! \e[0m"
      echo -e " ${INFO} \e[37m Installed version: ${INSTALLED} \e[0m "
      exit 1
    else
      echo -e " ${INFO} \e[37m Root.hints last updated ${mod}  \e[0m"
      echo -e " ${INFO} \e[37m Currently using version: ${INSTALLED} \e[0m  "

    fi
else
    echo -e " ${INFO} \e[33m No root.hints \e[0m"
fi

# DOWNLOAD ROOT HINTS

echo -e " ${INFO} \e[37m Downloading latest root.hints from https://www.internic.net \e[0m"
wget -O root.hints https://www.internic.net/domain/named.root > /dev/null 2>&1

if [ -f ./root.hints ]
then
  echo -e " ${TICK} \e[32m Download complete \e[0m"
  echo -e " ${INFO} \e[37m Version: ${AVAILABLE} \e[0m"
else
  echo -e " ${CROSS} \e[31m Download failed \e[0m"
  echo -e " ${INFO} \e[37m Please check internet connection and try running the script again \e[0m"
  echo -e " ${INFO} \e[37m Exiting... \e[0m"
  echo " "
  exit 2
fi

sleep 0.5

echo -e " ${INFO} \e[37m Moving root.hints to Unbound installation \e[0m"
sleep 0.5
rm -f /var/lib/unbound/root.hints
mv ./root.hints /var/lib/unbound
if [ -f /var/lib/unbound/root.hints ]
then
  echo -e " ${TICK} \e[32m root.hints moved to /var/lib/unbound \e[0m"
else
  echo -e " ${CROSS} \e[31m File move failed \e[0m"
  exit 2
fi

echo -e " ${INFO} \e[37m Cleaning up... \e[0m"
rm -f ./root.hints
sleep 0.5
echo -e " ${TICK} \e[32m Done! \e[0m"
echo -e " "
