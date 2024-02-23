#!/bin/bash
# This script is used to clean the template for deployment

# This script must run as root
echo "Checkin' for root"
if [[ $EUID -ne 0 ]]; then
echo "Relaunching as root"
sudo "$0" "$@"
exit $?
fi

# Bash strict mode
set -euo pipefail
IFS=$'\n\t'

# Remove the SSH host keys
rm -f /etc/ssh/ssh_host_*

# Remove the root user's shell history
rm -f /root/.bash_history

# Clear the pacman cache
paccache -rv --keep 0

# Rotate and clear the logs
journalctl --rotate --vacuum-time=1s

# Stop salt minion, but ensure it's enabled for next boot
systemctl stop salt-minion
systemctl disable salt-minion

# Clear salt minion cache
salt-call saltutil.clear_cache \
  || echo "Unable to clear salt cache"

# Stop tailscaled
systemctl stop tailscaled

# Remove tailscale state
rm -f /var/lib/tailscale/tailscaled.state

# Make sure tailscale grain indicates it's not authed
salt-call grains.set tailscale:authed false \
  || echo "Unable to set tailscale:authed grain"

# Remind the user to remove the node from tailscale
echo "On the tailscale admin console, remove the node from the network."

# Clean up salt minion keys
rm -f /etc/salt/pki/minion/*

# clean up the salt minion id
rm -f /etc/salt/minion_id

# Remind user to clean up minion on the master
echo -n 'On the salt master, run `sudo salt-key -d <minion-id>`'
echo "to remove the minion from the master."

# Clean up the machine ID
rm -f /etc/machine-id

# Clean up the udev rules
rm -f /etc/udev/rules.d/70-persistent-net.rules

# Clean up the temporary directory
rm -rf /tmp/*

# Clean up the log files
find /var/log -type f -exec truncate --size 0 {} \;
truncate -s 0 /var/log/salt/minion
truncate -s 0 /var/log/{btmp,lastlog,pacman.log,wtmp}

# Shutdown after a warning
shutdown -h 1