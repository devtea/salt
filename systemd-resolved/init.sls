resolved_service:
  service.running:
    - name: systemd-resolved
    - enable: True
    - watch:
      - file: resolved_config
      - file: resolve_conf_symlink

resolved_config:
  file.managed:
    - name: /etc/systemd/resolved.conf
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://common/files/resolved.conf

# Symlink the standard resolv.conf to the resolved stub
resolve_conf_symlink:
  file.symlink:
    - name: /etc/resolv.conf
    - target: /run/systemd/resolve/stub-resolv.conf
    - force: True

