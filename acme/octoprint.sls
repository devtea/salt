{% from "acme/map.jinja" import acme with context %}
{% from "octoprint/map.jinja" import octoprint with context %}

octoprint_cert_update_script:
  file.managed:
    - name: /usr/local/bin/octoprint_certs.sh
    - source: salt://acme/files/octoprint_certs.sh
    - user: root
    - group: root
    - mode: "0755"
    - template: jinja
    - context:
        acme: {{ acme }}
        octoprint: {{ octoprint }}
    - require_in:
      - cmd: acme_sh_register
    - require:
      - file: octoprint_cert_dir

octoprint_cert_dir:
  file.directory:
    - name: {{ octoprint.cert_dir }}
    - makedirs: True
    - user: {{ acme.user }}
    - group: {{ acme.user }}
    - mode: "0755"

