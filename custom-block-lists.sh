#!/bin/sh

VERSION=008

# COLORS
blackText=$(tput setaf 0)   # Black
redText=$(tput setaf 1)     # Red
greenText=$(tput setaf 2)   # Green
yellowText=$(tput setaf 3)  # Yellow
blueText=$(tput setaf 4)    # Blue
magentaText=$(tput setaf 5) # Magenta
cyanText=$(tput setaf 6)    # Cyan
whiteText=$(tput setaf 7)   # White
resetText=$(tput sgr0)      # Reset to default color

# RESULTS
TICK="[${greenText}✓${resetText}]"
INFO="[i]"
DONE="${greenText}Done!${resetText}"


clear
sleep 0.2
echo "================================================================"
echo "=====                Valiceemo adlists.list                ====="
echo "=====                   Credit to Wally3K                  ====="
echo "================================================================"

sleep 0.5
echo
echo "Script written by Valiceemo https://github.com/Valiceemo"
echo "All credit to Wally3K"
echo "The script is a simple means to add the lists compiled & managed by Wally3K to your own Pi-Hole install"
echo
echo "This list will take the lists from https://wally3k.github.io/ and add them to your pi-hole install"
echo
sleep 3
str="Creating backup copy of adlists.list ==> /etc/pihole/adlists.list.bk"
echo "  ${INFO} ${str}..."
sleep 0.5
sudo cp /etc/pihole/adlists.list /etc/pihole/adlists.list.bk
sleep 0.5
echo -e "  ${TICK} ${str}"
str="backup is at /etc/pihole/adlists.list.bk"
echo "  ${INFO} ${str}"
sleep 1
DOMAINS_BLOCKED_BEFORE=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
sleep 0.5

## Add Wally3K lists to Pi-hole, default is type=nocross, modify at own will / risk
str="Adding lists to /etc/pihole/adlists.list"
echo "  ${INFO} ${str}..."
echo | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
echo "#### Adlists modified by manunal script @ $(date)" | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
echo | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
curl --silent https://v.firebog.net/hosts/lists.php?type=nocross | sudo tee --append /etc/pihole/adlists.list >/dev/null 2>&1
sleep 2
echo "  ${DONE}"
echo
sleep 1
## run pihole gravity update
str="Starting pihole gravity...Please be patient"
echo "  ${INFO} ${str}..."

sleep 0.2
sudo bash /etc/.pihole/gravity.sh
sleep 1
echo
echo "  ${TICK} Completed, Pihole Gravity has been run with the added lists"
echo
str="Checking No of blocked domains"
echo "  ${INFO} ${str}..."
sleep 1
echo
str="Domains being blocked before update:" $DOMAINS_BLOCKED_BEFORE
echo "  ${INFO} ${str}"
echo "  ${INFO} Calculating new number of blocked domains..."
DOMAINS_BLOCKED_AFTER=`curl --silent "http://localhost/admin/api.php?summary"| jq '.domains_being_blocked'`
sleep 12
echo "  $(INFO} Domains being blocked after update:" $DOMAINS_BLOCKED_AFTER
sleep 0.5
