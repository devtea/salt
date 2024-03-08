influxdb_gpg_key:
  file.managed:
    - name: /root/influxdata-archive.key
    - source: https://repos.influxdata.com/influxdata-archive.key
    - source_hash: 943666881a1b8d9b849b74caebf02d3465d6beb716510d86a39f6c8e8dac7515
    - user: root
    - group: root
    - mode: "0644"

influxdb_gpg_trust:
  cmd.run:
    - name: "cat /root/influxdata-archive.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive.gpg > /dev/null"
    - onchanges:
      - file: influxdb_gpg_key

influxdb_apt_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/influxdata.list
    - contents: "deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main"