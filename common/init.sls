{% from "common/map.jinja" import packages with context %}
common_packages:
  pkg.installed:
    - names: 
      - bind-utils
      - git
      - htop
      - iotop
      - lsof
      - {{ packages.vim }}
      - zsh
      - python
      - python36-dateutil
      - rsync
      - strace
      - tmux
      - traceroute
      - tcpdump

set_timezone:
  timezone.system:
    - name: 'America/Chicago'


