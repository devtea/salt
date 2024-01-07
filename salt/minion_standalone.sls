{% from "common/map.jinja" import common with context %}

salt_minion_config:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt/files/minion_standalone
    - watch_in:
      - service: salt_minion_service

{% if grains["app"] is defined and "auto_highstate" in grains["app"] %}
salt_minion_service:
  service.running:
    - name: salt-minion
    - enable: true
    - require:
      - file: salt_minion_config
{% else %}
salt_minion_service:
  service.dead:
    - name: salt-minion
    - enable: false
{% endif %}

{% if grains["env"] is defined and grains["env"] == "vagrant" %}

salt_dir:
  file.directory:
    - name: /srv/salt/
    - user: vagrant
    - group: vagrant
salt_state_symlink:
  file.symlink:
    - name: /srv/salt/states
    - target: /vagrant/salt/roots
salt_pillar_symlink:
  file.symlink:
    - name: /srv/salt/pillar
    - target: /vagrant/salt/pillar

{% else %}

salt_dirs:
  file.directory:
    - names:
      - /srv/salt/states
      - /srv/salt/pillar
    - user: {{ common.primary_user.username }}
    - group: {{ common.primary_user.username }}
    - dir_mode: 755
    - file_mode: 644
    - recurse: 
      - user
      - group
      - mode
{% endif %}
