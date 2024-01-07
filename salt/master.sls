{% from "common/map.jinja" import common with context %}

salt_requisites:
  pkg.installed:
    - names:
      - python3-pygit2

salt_master_config:
  file.managed:
    - name: /etc/salt/master
    - source: salt://salt/files/master

salt_master_service:
  service.running:
    - name: salt-master
    - enable: true
    - require:
      - pkg: salt_requisites
    - watch:
      - file: salt_master_config
