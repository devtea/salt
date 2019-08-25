{% from "common/map.jinja" import common with context %}

salt_minion_config:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt/files/minion
    - watch_in:
      - service: salt_minion_service

salt_minion_service:
  service.running:
    - name: salt-minion
    - enable: true
    - require:
      - file: salt_minion_config

salt_dirs:
  file.directory:
    - names:
      - /srv/salt/states
      - /srv/salt/pillar
    - user: {{ common.primary_user.username }}
    - group: {{ common.primary_user.username }}
    - dir_mode: 755
    - file_mode: 644
    - recurse: 
      - user
      - group
      - mode

