salt_minion_config:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt/files/minion

salt_minion_service:
  service.running:
    - name: salt-minion
    - enable: true
    - watch:
      - file: salt_minion_config
