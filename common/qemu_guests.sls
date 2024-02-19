qemu_guest_pkg:
  pkg.installed:
    - name: qemu-guest-agent
    - refresh: True

# This may require a power cycle (not reboot) to take effect
qemu_guest_service:
  service.running:
    - name: qemu-guest-agent
    - enable: True
    - require:
      - pkg: qemu_guest_pkg