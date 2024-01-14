{% from "sshd/map.jinja" import sshd with context %}

# Ensure sshd is allowed through the firewall
sshd_firewalld:
  firewalld.present:
    - name: public
    - ports:
      - {{ sshd.port }}/tcp
    - require_in:
      - service: sshd_service