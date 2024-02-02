{% from "common/map.jinja" import common with context %}

common_packages:
  pkg.installed:
    - names: 
      - {{ common.packages.bind_tools }}
      - git
      - htop
      - iotop
      - lsof
      - lvm2
      - neovim
      - {{ common.packages.python }}
      - {{ common.packages.pydateutil }}
      - {{ common.packages.pyyaml }}
      - rsync
      - strace
      - sudo
      - tar
      - tig
      - tmux
      - traceroute
      - tree
      - tcpdump
      - wget
      - zsh

set_timezone:
  timezone.system:
    - name: 'America/Chicago'

timezone_manual:
  file.symlink:
    - name: /etc/localtime
    - target: /usr/share/zoneinfo/America/Chicago
    - onfail:
      - timezone: set_timezone

locale_us_utf8:
  locale.present:
    - name: en_US.UTF-8

set_default_locale:
  locale.system:
    - name: en_US.UTF-8
    - require:
      - locale: locale_us_utf8
