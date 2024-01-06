dnf_config:
  file.managed:
    - name: /etc/dnf/dnf.conf
    - source: salt://dnf/files/dnf.conf
