{% from "telegraf/map.jinja" import telegraf with context %}
# monitoring influxdb prometheus metrics

telegraf_influxdb_oss_metrics_conf:
  file.managed:
    - name: /etc/telegraf/telegraf.d/influxdb_oss.conf
    - source: salt://telegraf/files/influxdb_oss.conf
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - context:
        telegraf: {{ telegraf }}
    - require:
      - file: telegraf_conf_dir
    - watch_in:
      - service: telegraf_service

