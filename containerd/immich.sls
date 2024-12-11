{% from "containerd/map.jinja" import containerd with context %}
{% from "common/map.jinja" import common with context %}
{% set immich = salt['pillar.get']('immich') %}
{% set service = "immich" %}

# Additional customizations for immich
immich_env_file:
  file.managed:
    - name: {{ containerd.container_root }}/{{ service }}/.env
    - source: salt://containerd/files/services/{{ service }}.env
    - user: {{ common.primary_user.username }}
    - group: {{ common.primary_user.username }}
    - makedirs: True
    - template: jinja
    - context:
        containerd: {{ containerd | tojson }}
        immich: {{ immich | tojson }}
    - require:
      - file: containerd_root
