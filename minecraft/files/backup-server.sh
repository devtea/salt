#!/bin/bash
[ $UID -eq 0 ] && exit 

DATE="$(date +%F-%H.%M.%S)"
BACKUP_NAME="/srv/minecraft/backup/world_one_backup_${DATE}.tgz"
PASS={{ minecraft.rcon_pass }}

mkdir -p /srv/minecraft/backup
mkdir -p /vagrant/backups/

/usr/local/bin/mcrcon -H 127.0.0.1 -p "${PASS}" "say Starting backup, server may lag..." || true
/usr/local/bin/mcrcon -H 127.0.0.1 -p "${PASS}"  save-off || true
/usr/local/bin/mcrcon -H 127.0.0.1 -p "${PASS}" save-all || true
sleep 5
rsync -av --delete /srv/minecraft/world_one /srv/minecraft/backup/
tar -czvf "${BACKUP_NAME}" /srv/minecraft/backup/world_one/

/usr/local/bin/mcrcon -H 127.0.0.1 -p "${PASS}" save-on || true
/usr/local/bin/mcrcon -H 127.0.0.1 -p "${PASS}" "say Backup complete." || true
rsync "${BACKUP_NAME}" /vagrant/backups/

# Clean up old and malformed backups
find /srv/minecraft/backup/ -type f -iname '*.tgz' -mtime +7 -delete
find /srv/minecraft/backup/ -type f -iname '*.tgz' ! -size +2M -delete
find /vagrant/backups/ -type f -iname '*.tgz' -mtime +30 -delete
find /vagrant/backups/ -type f -iname '*.tgz' ! -size +2M -delete
