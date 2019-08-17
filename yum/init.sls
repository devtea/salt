yum_config:
  file.managed:
    - name: /etc/yum.conf
    - source: salt://yum/files/yum.conf
