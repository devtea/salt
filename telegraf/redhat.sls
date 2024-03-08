influx_repo:
  file.managed:
    - name: /etc/yum.repos.d/influx.repo
    - source: salt://telegraf/files/influxdb.repo