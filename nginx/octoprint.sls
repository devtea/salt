nginx_octoprint_conf:
  file.managed:
    - name: /etc/nginx/conf.d/octoprint.conf
    - source: salt://nginx/files/octoprint.conf
    - user: root
    - group: root
    - mode: "0644"