{% from "telegraf/map.jinja" import telegraf with context %}

{% if grains["os_family"] == "Debian" %}
include: 
  - telegraf.debian

telegraf_pkg:
  pkg.installed:
    - name: telegraf
    - require: 
      - sls: telegraf.debian
    - require_in:
      - file: telegraf_conf

{% elif grains["os_family"] == "RedHat" %}
include: 
  - telegraf.redhat

telegraf_pkg:
  pkg.installed:
    - name: telegraf
    - require: 
      - sls: telegraf.redhat
    - require_in:
      - file: telegraf_conf

{% elif grains["os_family"] == "Arch" %}
include: 
  - telegraf.arch

{% endif %}

telegraf_conf_dir:
  file.directory:
    - name: /etc/telegraf/telegraf.d/
    - user: root
    - group: root
    - mode: "0755"

# Base telegraf configuration
telegraf_conf:
  file.managed:
    - name: /etc/telegraf/telegraf.conf
    - source: salt://telegraf/files/telegraf.conf
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - context:
        telegraf: {{ telegraf }}

telegraf_default_inputs_conf:
  file.managed:
    - name: /etc/telegraf/telegraf.d/inputs.defaults.conf
    - source: salt://telegraf/files/inputs.defaults.conf
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - context:
        telegraf: {{ telegraf }}
    - require:
      - file: telegraf_conf_dir

telegraf_influxdb_output_conf:
  file.managed:
    - name: /etc/telegraf/telegraf.d/outputs.influxdb.conf
    - source: salt://telegraf/files/outputs.influxdb.conf
    - user: root
    - group: root
    - mode: "0644"
    - template: jinja
    - context:
        telegraf: {{ telegraf }}
    - require:
      - file: telegraf_conf_dir