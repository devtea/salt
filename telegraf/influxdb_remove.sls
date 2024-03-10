{% from "telegraf/map.jinja" import telegraf with context %}
# monitoring influxdb prometheus metrics

telegraf_influxdb_oss_metrics_conf:
  file.absent:
    - name: /etc/telegraf/telegraf.d/influxdb_oss.conf

