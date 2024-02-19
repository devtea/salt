qemu_guest_pkg:
  pkg.installed:
    - name: qemu-guest-agent
    - refresh: True

qemu_guest_service:
  service.running:
    - name: qemu-guest-agent
    - enable: True
    - require:
      - pkg: qemu_guest_pkg