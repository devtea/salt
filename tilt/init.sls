{% set tilt = pillar["tilt"] %}

tilt_user:
  user.present:
    - name: tilt
    - shell: /usr/sbin/nologin
    - createhome: True
    - gid: daemon

tilt_requirements:
  pkg.installed:
    - names:
      - python3-dev
      - python3-pip
      - python3-virtualenv
      - python3-venv
      - libbluetooth-dev
      - libcap2-bin

tilt_pitch_venv:
  virtualenv.managed:
    - name: /home/tilt/pitch_venv/
    - user: tilt
    - pip_upgrade: true
    - require:
      - pkg: tilt_requirements

tilt_pip_update:
  cmd.run:
    - name: /home/tilt/pitch_venv/bin/pip install --upgrade pip setuptools
    - user: tilt
    - onchanges:
      - virtualenv: tilt_pitch_venv

tilt_pitch_pip:
  pip.installed:
    - pkgs:
      - tilt-pitch
      - influxdb-client
    - user: tilt
    - bin_env: /home/tilt/pitch_venv
    - require: 
      - virtualenv: tilt_pitch_venv

# This runs every highstate. Not super auto-highstate friendly
tilt_pitch_update:
  cmd.run:
    - name: >
        /home/tilt/pitch_venv/bin/pip 
        install
        --upgrade
        --upgrade-strategy eager 
        tilt-pitch
        influxdb-client
    - user: tilt
    - require:
      - pkg: tilt_requirements
      - virtualenv: tilt_pitch_venv

tilt_pitch_config:
  file.managed:
    - name: /home/tilt/pitch.json
    - source: salt://tilt/files/pitch.json
    - user: tilt
    - group: daemon
    - mode: "0600"
    - template: jinja
    - context:
        tilt: {{ tilt | tojson }}
    - require:
      - user: tilt_user

tilt_service_file:
  file.managed:
    - name: /etc/systemd/system/pitch.service
    - source: salt://tilt/files/pitch.service

tilt_reload_daemon:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: tilt_service_file

tilt_pitch_service:
  service.running:
    - name: pitch
    - enable: true
    - require:
      - cmd: tilt_reload_daemon
    - watch:
      - file: tilt_service_file
      - pip: tilt_pitch_pip
