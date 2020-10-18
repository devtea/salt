{% from "common/map.jinja" import common with context %}

arch_packages:
  pkg.installed:
    - names: 
      - base-devel
      - neovim
      - {{ common.packages.python_neovim }}
