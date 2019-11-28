#!/bin/bash
# Ensure this script isn't being run by root by accident (e.g. with salt).
[ $UID -eq 0 ] && exit 7

DATE="$(date +%F-%H.%M.%S)"
BACKUP_NAME="world_one_backup_${DATE}.tgz"
BACKUP_DIR="/srv/backup/srv/minecraft/"
PASS="{{ minecraft.rcon_pass }}"
MCRCON_CMD="/usr/local/bin/mcrcon -H 127.0.0.1 -p \"${PASS}\""

# Start by warning users, disabling auto save, and force saving the world.
$MCRCON_CMD "say Starting backup, server may lag..." || true
$MCRCON_CMD save-off || true
$MCRCON_CMD "say Force saving world..." || true
$MCRCON_CMD save-all || true
sleep 5
$MCRCON_CMD "say Save complete, backing up world..." || true

# Salt automation will have already created /vagrant/backups/srv/minecraft
# First sync the world and any other shit to the backup location
rsync -av --delete /srv/minecraft/{plugins,world_one} "$BACKUP_DIR"

# With the file copy done we can re-enable world auto-saving.
$MCRCON_CMD save-on || true

# Then cd and tar the files using a "full" path for simple restore.
cd /srv/backups/
nice tar -czvf "${BACKUP_NAME}" srv

# Copy from the local backup location to the host system on /vagrant
nice ionice -c 2 rsync "${BACKUP_NAME}" /vagrant/backups/
$MCRCON_CMD "say Backup complete." || true

# Clean up old and malformed backups
find "$BACKUP_DIR" -type f -iname '*.tgz' -mtime +7 -delete
find "$BACKUP_DIR" -type f -iname '*.tgz' ! -size +2M -delete
find /vagrant/backups/ -type f -iname '*.tgz' -mtime +30 -delete
find /vagrant/backups/ -type f -iname '*.tgz' ! -size +2M -delete
