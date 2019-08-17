base:
  'os_family:RedHat':
    - match: grain
    - common.centos
    - sshd.selinux

  "*":
    - common
    - common.users
    - salt.minion
    - sshd

  "app:mailserver":
    - match: grain
    - mailserver
