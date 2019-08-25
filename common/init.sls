{% from "common/map.jinja" import common with context %}

common_packages:
  pkg.installed:
    - names: 
      - {{ common.packages.bind_tools }}
      - git
      - htop
      - iotop
      - lsof
      - {{ common.packages.vim }}
      - zsh
      - python
      - {{ common.packages.pydateutil }}
      - {{ common.packages.pyyaml }}
      - rsync
      - strace
      - tig
      - tmux
      - traceroute
      - tcpdump
      - wget

set_timezone:
  timezone.system:
    - name: 'America/Chicago'
