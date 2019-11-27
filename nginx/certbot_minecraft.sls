certbot_nginx_config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/minecraft_certbot_nginx.conf
