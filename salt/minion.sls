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
      - file: salt_minion_service_override
    - require:
      - cmd: salt_minion_systemd_reload

salt_minion_service_override:
  file.managed:
    - name: /etc/systemd/system/salt-minion.service
    - source: salt://salt/files/salt-minion.service

salt_minion_systemd_reload:
  cmd.run:
    - name: systemctl daemon-reload
    - watch:
      - file: salt_minion_service_override