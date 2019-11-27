base:
  'os_family:RedHat':
    - match: grain
    - common.centos
    - sshd.selinux
    - yum
    - yum.auto_update

  "*":
    - common
    - common.users
    - salt.minion
    - salt.auto_highstate
    - sshd

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
