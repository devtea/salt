{% from "common/map.jinja" import common with context %}
centos_epel:
  pkg.installed:
    - name: epel-release

centos_packages:
  pkg.installed:
    - names: 
      - policycoreutils
      - policycoreutils-python-utils
      - neovim
      - {{ common.packages.python_neovim }}
    - require: 
      - pkg: centos_epel

bootstrap_cleanup:
  pkg.removed:
    - name: python34

selinux_enforce:
  selinux.mode:
    - name: enforcing