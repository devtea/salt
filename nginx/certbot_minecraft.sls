certbot_pkg:
  pkg.installed:
    - name: certbot

certbot_nginx_config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/minecraft_certbot_nginx.conf

certbot_renewal:
  file.managed:
    - name: /etc/systemd/system/certbot_renewal.service
    - source: salt://nginx/files/certbot_renewal.service
    - mode: "0755"

certbot_renewal_service:
  service.enabled:
    - name: certbot_renewal

certbot_systemd_reload_daemon:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges: 
      - file: certbot_renewal
      - file: certbot_renewal_timer

certbot_renewal_timer:
  file.managed:
    - name: /etc/systemd/system/certbot_renewal.timer
    - source: salt://nginx/files/certbot_renewal.timer
    - mode: "0755"

certbot_renewal_timer_enable:
  cmd.run:
    - name: 'systemctl enable certbot_renewal.timer'
    - creates: /etc/systemd/system/timers.target.wants/certbot_renewal.timer
    - onchanges: 
      - file: certbot_renewal_timer
    - require: 
      - cmd: certbot_systemd_reload_daemon

certbot_renewal_timer_start:
  cmd.run:
    - name: 'systemctl start certbot_renewal.timer'
    - onchanges:
      - file: certbot_renewal_timer
    - require: 
      - cmd: certbot_systemd_reload_daemon

