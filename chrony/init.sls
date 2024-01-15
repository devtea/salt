chrony_pkg:
  pkg.installed:
    - name: chrony

chrony_conf:
  file.managed:
    - name: /etc/chrony.conf
    - source: salt://chrony/files/chrony.conf
    - user: root
    - group: root
    - mode: 644

chrony_service:
  service.running:
    - name: chronyd
    - enable: True
    - require:
      - pkg: chrony_pkg
    - watch:
      - file: chrony_conf