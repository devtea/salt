{% from "sshd/map.jinja" import sshd with context %}

# Enable a configurable sshd port
sshd_selinux_port:
  selinux.port_policy_present:
    - name: tcp/{{ sshd.port }}
    - sel_type: ssh_port_t
    - require_in:
      - service: sshd_service