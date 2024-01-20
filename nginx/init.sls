nginx_pkgs:
  pkg.installed: 
    - pkgs:
      - nginx

# Assume we're not going to use the default nginx.conf
nginx_disable_default:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require: 
      - pkg: nginx_pkgs

nginx_service:
  service.running:
    - name: nginx
    - enable: true
    - require:
      - pkg: nginx_pkgs
      - file: nginx_disable_default
