centos_epel:
  pkg.installed:
    - name: epel-release

centos_packages:
  pkg.installed:
    - names: 
      - policycoreutils-python
      - python3-neovim
      - neovim
    - require: 
      - pkg: centos_epel


bootstrap_cleanup:
  pkg.removed:
    - name: python34

