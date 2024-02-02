{% from "salt/map.jinja" import salt with context %}

salt_requisites:
  pkg.installed:
    - names:
      - gpgme
      - pinentry
      - python3-gpg

salt_master_config:
  file.managed:
    - name: /etc/salt/master
    - source: salt://salt/files/master
    - template: jinja
    - context:
        salt: {{ salt | tojson }}

salt_master_service:
  service.running:
    - name: salt-master
    - enable: true
    - require:
      - pkg: salt_requisites
    - watch:
      - file: salt_master_config

salt_gpg_dir:
  file.directory:
    - name: /etc/salt/gpgkeys
    - user: salt
    - group: salt
    - recurse:
      - user
      - group
    - mode: "0700"
