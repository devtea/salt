{% from "sshd/map.jinja" import sshd with context %}

sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd/files/sshd_config
    - template: jinja
    - context:
        sshd: {{ sshd | tojson }}

sshd_service:
  service.running:
    - name: sshd
    - watch: 
      - file: sshd_config
