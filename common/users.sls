{% from "common/map.jinja" import common with context %}

primary_user_{{ common.primary_user.username }}:
  group.present:
    - name: {{ common.primary_user.username }}
    - gid: {{ common.primary_user.gid }}
  user.present:
    - name: {{ common.primary_user.username }}
    - uid: {{ common.primary_user.uid }}
    - gid: {{ common.primary_user.gid }}
    - shell: /bin/zsh
    - enforce_password: true
    - password: '!!'
    - require: 
      - group: primary_user_{{ common.primary_user.username }}

{% if "ssh_keys" in common.primary_user and common.primary_user.ssh_keys|length > 0 %}
primary_user_keys_{{ common.primary_user.username }}:
  ssh_auth.present:
    - user: {{ common.primary_user.username }}
    - names: {{ common.primary_user.ssh_keys }}
    - require: 
      - user: primary_user_{{ common.primary_user.username }}
{% endif %}

primary_user_sudo_{{ common.primary_user.username }}:
  file.managed:
    - name: /etc/sudoers.d/{{ common.primary_user.username }}
    - contents: |
        {{ common.primary_user.username }} ALL=(ALL) NOPASSWD: ALL
