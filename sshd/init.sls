sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd/files/sshd_config
    - template: jinja

sshd_service:
  service.running:
    - name: sshd
    - watch: 
      - file: sshd_config
