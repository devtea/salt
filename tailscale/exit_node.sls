tailscale_exit_ipv4_forwarding:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1

tailscale_exit_ipv6_forwarding:
  sysctl.present:
    - name: net.ipv6.conf.all.forwarding
    - value: 1

tailscale_exit_setup:
  cmd.run:
    - name: "tailscale up --advertise-exit-node"
    - require:
      - sysctl: tailscale_exit_ipv4_forwarding
      - sysctl: tailscale_exit_ipv6_forwarding
    - creates: /var/lib/tailscale/.salt_exit_node

tailscale_exit_setup_state:
  file.touch:
    - name: /var/lib/tailscale/.salt_exit_node
    - require: 
      - cmd: tailscale_exit_setup
    - onchanges: 
      - cmd: tailscale_exit_setup
