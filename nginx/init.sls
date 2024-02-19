nginx_pkgs:
  pkg.installed: 
    - pkgs:
      - nginx

# Assume we're not going to use the default nginx.conf where enabled
nginx_disable_default:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx_pkgs

nginx_conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - template: jinja

nginx_conf.d:
  file.directory:
    - name: /etc/nginx/conf.d
    - mode: "0755"

nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - pkg: nginx_pkgs
      - file: nginx_disable_default
    - watch:
      - file: nginx_conf
