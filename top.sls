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
  # Common items
  #
  "*":
    - common
    - common.users
    - salt.minion
    - sshd

  # 
  # OS specific states
  #
  'os_family:RedHat':
    - match: grain
    - common.centos
    - sshd.selinux
    - yum
    - yum.auto_update

  'os_family:Arch':
    - match: grain
    - pacman
    - common.arch

  'os:Raspbian':
    - match: grain
    - common.raspian

  #
  # App grains
  #
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

  "app:nginx": 
    - match: grain
    - nginx
    - nginx.certbot

  "app:octoprint":
    - match: grain
    - octoprint

  # Tailscale vpn
  "G@app:tailscale and G@os:Raspbian":
    - match: compound
    - tailscale.repo_debian
    - tailscale
  "G@app:tailscale and G@os_family:Arch":
    - match: compound
    - tailscale

  # Tailscale exit nodes
  "app:tailscale_exit_node":
    - match: grain
    - tailscale.exit_node

  # Tilt pi devices (using tilt-pitch)
  "tilt*":
    - tilt
