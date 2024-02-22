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

tailscale_exit_extra_pkgs:
  pkg.installed:
    - pkgs:
      - ethtool

tailscale_exit_transport_layer_offloads:
  file.managed:
    - name: /etc/systemd/foo
    - source: salt://tailscale/files/tailscale_udp_offload.service
    - template: jinja
    - require:
      - pkg: tailscale_exit_extra_pkgs

tailscale_systemd_reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: tailscale_exit_transport_layer_offloads

tailscale_exit_transport_layer_offloads_enable:
  service.running:
    - name: tailscale_udp_offload
    - enable: True
    - require:
      - cmd: tailscale_systemd_reload
    - watch:
      - file: tailscale_exit_transport_layer_offloads