tuned_pkg:
  pkg.installed: 
    - name: tuned

tuned_service_base:
  service.running:
    - name: tuned
    - require:
      - pkg: tuned_pkg

tuned_conf:
  file.managed:
    - name: /etc/tuned/tuned-main.conf
    - source: salt://tuned/files/tuned-main.conf
    - user: root
    - group: root
    - mode: "0644"

tuned_standard_conf:
  file.managed: 
    - name: /etc/tuned/standard/tuned.conf
    - source: salt://tuned/files/standard.conf
    - makedirs: True

tuned_active_profile:
  tuned.profile:
    - name: standard
    - require:
      - service: tuned_service_base

tuned_service:
  service.running:
    - name: tuned
    - enable: True
    - watch:
      - file: tuned_conf
      - file: tuned_standard_conf
      - tuned: tuned_active_profile