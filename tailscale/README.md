Tailscale
=========

registering hosts
-----------------

The auth key should be set in the pillar:

```yaml
common:
  tailscale:
    key: tskey-auth-foooooooooooo-baaaaaaaaaaaaaaaaaaaaaaaar
```
Troubleshooting
---------------

### LXC
To bring up Tailscale in an unprivileged container, access to the /dev/tun device can be enabled in the config for the LXC. For example, using Proxmox 7.0 to host as unprivileged LXC with ID 112, the following lines would be added to /etc/pve/lxc/112.conf:

```ini
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```

From: https://tailscale.com/kb/1130/lxc-unprivileged