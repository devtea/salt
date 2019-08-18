base:
  'os_family:RedHat':
    - match: grain
    - common.centos
    - sshd.selinux
    - yum

  "*":
    - common
    - common.users
    - salt.minion
    - salt.auto_highstate
    - sshd

  "app:mailserver":
    - match: grain
    - app.mailserver
