# Proxies and certs for containerd services
{% from "containerd/map.jinja" import containerd with context %}

{% for service in containerd.services %}
nginx_containerd_{{ service }}_conf:
  file.managed:
    - name: /etc/nginx/conf.d/containerd.conf
    - source: salt://nginx/files/containerd.conf
    - template: jinja
    - context:
        containerd: {{ containerd | tojson }}
        service: {{ service }}
    - user: root
    - group: root
    - mode: "0644"
    - watch_in:
      - service: nginx_service
{% endfor %}