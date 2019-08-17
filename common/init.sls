{% from "common/map.jinja" import packages with context %}
common_packages:
  pkg.installed:
    - names: 
      - htop
      - {{ packages.vim }}
      - zsh

set_timezone:
  timezone.system:
    - name: 'America/Chicago'


