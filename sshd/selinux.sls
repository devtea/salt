# Enable a nonstandard sshd port
sshd_selinux_port:
  selinux.port_policy_present:
    - name: tcp/9022
    - sel_type: ssh_port_t
