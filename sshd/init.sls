sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd/files/sshd_config
    - template: jinja
