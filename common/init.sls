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
      - zsh

set_timezone:
  timezone.system:
    - name: 'America/Chicago'

locale_us_utf8:
  locale.present:
    - name: en_US.UTF-8

set_default_locale:
  locale.system:
    - name: en_US.UTF-8
    - require:
      - locale: locale_us_utf8

