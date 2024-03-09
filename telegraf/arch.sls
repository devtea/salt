{% from "common/map.jinja" import common with context %}

telegraf_aur_git:
  git.latest:
    - name: https://aur.archlinux.org/telegraf-bin.git
    - target: /home/{{ common.primary_user.username }}/build/telegraf-bin/
    - rev: HEAD
    - user: {{ common.primary_user.username }}

telegraf_build:
  cmd.run:
    - name: makepkg -risc --noconfirm
    - cwd: /home/{{ common.primary_user.username }}/build/telegraf-bin/
    - runas: {{ common.primary_user.username }}
    - onchanges:
      - git: telegraf_aur_git