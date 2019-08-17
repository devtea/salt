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
    - sshd

  "app:mailserver":
    - match: grain
    - mailserver
