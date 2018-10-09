#!/bin/sh

# move to the dir
cd /home/pi/pi-hole

# sort blacklist, remove blank lines and write to blacklist.txt
sort /etc/pihole/blacklist.txt | sed '/^$/d' > blacklist.txt

# sort whitelist, remove blank lines and write to valiceemo-whitelist.txt
sort /etc/pihole/whitelist.txt | sed '/^$/d' > valiceemo-whitelist.txt

# grab regex list and write to valiceemo-regex.list
cp /etc/pihole/regex.list valiceemo-regex.list

# add the new file to git
git add blacklist.txt valiceemo-whitelist.txt valiceemo-regex.list

# commit
git commit -m "auto commit" blacklist.txt valiceemo-whitelist.txt valiceemo-regex.list

# push to github
git push origin master >/dev/null 2>&1
