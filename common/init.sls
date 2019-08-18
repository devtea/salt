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
      - python36-PyYAML
      - python36-dateutil
      - rsync
      - strace
      - tmux
      - traceroute
      - tcpdump

bootstrap_cleanup:
  pkg.removed:
    - name: python34


set_timezone:
  timezone.system:
    - name: 'America/Chicago'


