{% from "acme/map.jinja" import acme with context %}
{% from "gitlab/map.jinja" import gitlab with context %}

gitlab_cert_update_script:
  file.managed:
    - name: /usr/local/bin/gitlab_certs.sh
    - source: salt://acme/files/gitlab_certs.sh
    - user: root
    - group: root
    - mode: "0755"
    - template: jinja
    - context:
        acme: {{ acme }}
        gitlab: {{ gitlab }}
    - require_in:
      - cmd: acme_sh_register

gitlab_cert_dir:
  file.directory:
    - name: /etc/gitlab/ssl
    - user: {{ acme.user }}
    - group: {{ acme.user }}
    - mode: "0755"

