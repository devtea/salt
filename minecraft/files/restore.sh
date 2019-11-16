#!/bin/bash
set -euo pipefail

exec >> /srv/minecraft/restore.log
exec 2>&1

[ $UID -eq 0 ] && exit 7
cd /srv/minecraft

# Let salt know this has run, successfully or otherwise
touch /srv/minecraft/.restore_script_flag

# Get the newest backup filename
set +u
unset -v latest
for file in "/vagrant/backups"/*backup*tgz; do
    [[ $file -nt $latest ]] && latest=$file
done

# No files? exit.
[ -z $latest ] && exit 1
set -u

# TODO move existing files if they exist

rsync $latest /srv/minecraft/
tar -xf /srv/minecraft/*backup*.tgz

mv ./srv/minecraft/backup/* .
rm -rf ./srv
