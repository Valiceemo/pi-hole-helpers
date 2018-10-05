#!/bin/sh

# move to the dir
cd /home/pi/pi-hole

# sort blacklist, remove blank lines and write to blacklist.txt
sort /etc/pihole/blacklist.txt | sed '/^$/d' > blacklist.txt

# sort whitelist, remove blank lines and write to valiceemo-whitelist.txt
sort /etc/pihole/whitelist.txt | sed '/^$/d' > valiceemo-whitelist.txt

cp /etc/pihole/regex.list valiceemo-regex.list

# add the new file to git
git add .

# commit
git commit -F blacklist.txt
git commit -F valiceemo-whitelist.txt

# push to github
git push origin master
