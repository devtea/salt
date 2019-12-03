#!/bin/bash
# Script to find the newest (if any) backup in the backup folder
# and restore it to the default server location.

# strict mode
set -euo pipefail
IFS=$'\n\t'

# Redirect all script output to a log file 
exec >> /srv/minecraft/restore.log
exec 2>&1

# Prevent this script from being run by root.
[ $UID -eq 0 ] && exit 7

# Let salt know this has run, successfully or otherwise
touch /srv/minecraft/.restore_script_flag

# Get the newest backup filename
set +u
unset -v latest
for file in "/vagrant/backups"/*backup*tgz; do
    [[ $file -nt $latest ]] && latest=$file
done

# No files? exit.
[ -z $latest ] && exit 0
set -u

# move existing files if they exist
[ -e /srv/minecraft/world_one ] && mv /srv/minecraft/world_one{,.bak}
[ -e /srv/minecraft/plugins ] && mv /srv/minecraft/plugins{,.bak}
mkdir /srv/minecraft/old

# extract the backup, ensuring we're in the right location
cd /srv/minecraft
mkdir /srv/minecraft/plugins/
tar -xf $latest

# copy plugins
rsync -av --delete /vagrant/backups/plugins/dynmap /srv/minecraft/plugins
