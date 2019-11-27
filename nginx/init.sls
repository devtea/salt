nginx_pkgs:
  pkg.installed: 
    - pkgs:
      - nginx
      - certbot
      - certbot-nginx

nginx_service:
  service.running:
    - name: nginx
    - enable: true
    - require: 
      - pkg: nginx_pkgs
