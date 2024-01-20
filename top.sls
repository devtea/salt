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
    - tailscale
  
  # Containers don't need some things
  "* not G@virtual:container":
    - tuned
    - chrony

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

  'os:Raspbian':
    - match: grain
    - common.raspian
    - tailscale.repo_debian

  #
  # App grains
  #
  "app:gitlab":
    - match: grain
    - gitlab

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

  "app:salt-master":
    - match: grain
    - salt.master

  # Tailscale exit nodes
  "app:tailscale_exit_node":
    - match: grain
    - tailscale.exit_node

  # Tilt pi devices (using tilt-pitch)
  "tilt*":
    - tilt
