{% from "telegraf/map.jinja" import telegraf with context %}
{% set proxmox = salt["pillar.get"]("proxmox", {}) %}
# monitoring proxmox

telegraf_proxmox_metrics_conf:
  file.managed:
    - name: /etc/telegraf/telegraf.d/proxmox.conf
    - source: salt://telegraf/files/proxmox.conf
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - context:
        telegraf: {{ telegraf }}
        proxmox: {{ proxmox }}
    - require:
      - file: telegraf_conf_dir
    - watch_in:
      - service: telegraf_service

