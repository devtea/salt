{% from "sshd/map.jinja" import sshd with context %}

sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd/files/sshd_config
    - template: jinja
    - context:
        sshd: {{ sshd | tojson }}

ssh_hardening_conf:
  file.managed:
    - name: /etc/ssh/sshd_config.d/sshd_hardening.conf
    - source: salt://sshd/files/sshd_hardening.conf
    - template: jinja

# Remove small diffie-hellman moduli
sshd_scrub_moduli:
  cmd.run:
    - name: > 
        awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe &&
        mv -f /etc/ssh/moduli.safe /etc/ssh/moduli 
    - onlyif: "[ $(awk '$5 >= 3071' /etc/ssh/moduli | wc -l | awk '{print $1}') -lt $(wc -l /etc/ssh/moduli | awk '{print $1}') ]"

sshd_service:
  service.running:
    - name: sshd
    - watch:
      - file: sshd_config
      - cmd: sshd_scrub_moduli