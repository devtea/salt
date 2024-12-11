base:
  #
  # Items to run before anything else like setting up mounts
  #
  "app:vagrant_srv":
    - match: grain
    - common.vagrant_srv

  "app:auto_highstate":
    - match: grain
    - salt.auto_highstate

  #
  # Common
  #
  "*":
    - salt.minion

  #
  # Common items unless app:appliance is set
  #
  "* not G@app:appliance":
    - match: compound
    - common
    - common.users
    - sshd
    - tailscale
    - telegraf
  
  # Tuned on supported OS's, not containers/appliances
  "(G@os_family:RedHat or G@os_family:Debian) not G@virtual:container not G@app:appliance":
    - match: compound
    - tuned

  # Containers and appliances don't need chrony / NTP
  "* not G@virtual:container not G@app:appliance":
    - match: compound
    - chrony
  
  "virtual:kvm":
    - match: grain
    - common.qemu_guests

  # 
  # OS specific states
  #
  'os_family:RedHat':
    - match: grain
    - common.rhel
    - dnf
    - dnf.auto_update
    - tailscale.repo_rhel

  'G@os_family:Redhat not G@virtual:container':
    - match: compound
    - common.selinux
    - sshd.selinux
    - sshd.firewalld

  'os_family:Arch':
    - match: grain
    - pacman
    - common.arch
    - systemd-resolved

  '(G@os:Raspbian or G@os:Debian) not G@app:appliance':
    - match: compound
    - common.raspian
    - tailscale.repo_debian

  #
  # App grains
  #
  "app:acme":
    - match: grain
    - acme.acme_sh
  "app:acme_truenas":
    - match: grain
    - acme.truenas

  "app:containerd":
    - match: grain
    - containerd
    - nginx
    - nginx.containerd
  "G@app:containerd and G@app:acme":
    - match: compound
    - acme.containerd

  "app:gitlab":
    - match: grain
    - gitlab
  "G@app:gitlab and G@app:acme":
    - match: compound
    - acme.gitlab

  "app:mailserver":
    - match: grain
    - app.mailserver

  "app:minecraft":
    - match: grain
    - java
    - minecraft

  "app:minecraft_dynmap_reverse_proxy":
    - match: grain
    - minecraft.dynmap_reverse_proxy
    - nginx
    - nginx.certbot_minecraft

  "app:nginx":
    - match: grain
    - nginx

  "app:octoprint":
    - match: grain
    - octoprint
    - nginx
    - nginx.octoprint
  "G@app:octoprint and G@app:acme":
    - match: compound
    - acme.octoprint

  "G@app:pihole and G@app:appliance":
    - match: compound
    - common.users
    - salt.minion
    - sshd

  "app:salt-master":
    - match: grain
    - salt.master

  # Tailscale exit nodes
  "app:tailscale_exit_node":
    - match: grain
    - tailscale.exit_node

  # Tilt pi devices (using tilt-pitch)
  "app:tilt":
    - match: grain
    - tilt

  # Generic server monitoring with telegraf
  "app:telegraf":
    - match: grain
    - telegraf
  # monitoring influxdb oss metrics with telegraf
  "app:telegraf_influxdb_oss_monitor":
    - match: grain
    - telegraf.influxdb
  # Proxmox monitoring with telegraf
  "G@app:telegraf and G@app:proxmox":
    - match: compound
    - telegraf.proxmox

  # additional states for immich
  "containerd:services:immich":
    - match: grain
    - containerd.immich