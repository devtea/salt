{% from "acme/map.jinja" import acme with context %}
{% from "containerd/map.jinja" import containerd with context %}

{% for service in containerd.services %}
containerd_{{ service }}_cert_update_script:
  file.managed:
    - name: /usr/local/bin/containerd_{{ service }}_certs.sh
    - source: salt://acme/files/containerd_certs.sh
    - user: root
    - group: root
    - mode: "0755"
    - template: jinja
    - context:
        acme: {{ acme | tojson }}
        containerd: {{ containerd | tojson }}
        service: {{ service }}
    - require_in:
      - cmd: acme_sh_register
    - require:
      - file: containerd_cert_dir
{% endfor %}

# Set the domain grains needed for acme. will sometimes require a second 
# highstate, but w/e
# Wrapping this whole stanza in a for loop doesn't work, since salt seems
# to not like deep inspection of the grains when setting dicts.
#
# ⚠️ Note: this appears to never get updated after it's first set...
containerd_acme_grain:
  grains.list_present:
    - name: acme:domains
    - value:
{%- for service in containerd.services %}
      - domain: "{{ containerd["services_conf"][service]["domain"] }}"
        reloadcmd: /usr/local/bin/containerd_{{ service }}_certs.sh
{%- endfor %}

containerd_cert_dir:
  file.directory:
    - name: {{ containerd.cert_dir }}
    - makedirs: True
    - user: {{ acme.user }}
    - group: {{ acme.user }}
    - mode: "0755"

