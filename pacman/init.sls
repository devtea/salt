pacman_contrib_scripts:
  pkg.installed:
    - name: pacman-contrib

pacman_find_sh:
  file.managed:
    - name: /usr/local/sbin/find_pacnew.sh
    - source: salt://pacman/files/find_pacnew.sh
    - user: root
    - group: root
    - mode: "0744"

pacman_hooks:
  file.recurse:
    - name: /etc/pacman.d/hooks/
    - source: salt://pacman/files/hooks/
    - clean: False
    - require:
      - file: pacman_find_sh