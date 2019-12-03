base:
  #
  # Items to run before anything else like setting up mounts
  #
  "app:vagrant_srv":
    - match: grain
    - common.vagrant_srv

  #
  # Common items
  #
  "*":
    - common
    - common.users
    - salt.minion
    - salt.auto_highstate
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

