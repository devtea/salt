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

# TODO Upgrade all pip packages on highstate
tilt_pip_update:
  cmd.run:
    - name: /home/tilt/pitch_venv/pip install --upgrade pip setuptools
    - onchanges:
      - virtualenv: tilt_pitch_venv

#tilt_pip_update:
#  pip.uptodate:
#    - user: tilt
#    - bin_env: /home/tilt/pitch_venv
#    - require:
#      - pkg: tilt_requirements
#      - user: tilt_user
#      - virtualenv: tilt_pitch_venv
#    - require_in:
#      - pip: tilt_pitch_pip

tilt_pitch_pip:
  pip.installed:
    - pkgs:
      - tilt-pitch
      - influxdb-client
    - user: tilt
    - bin_env: /home/tilt/pitch_venv

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
      - file: tilt_service_file
      - cmd: tilt_reload_daemon
      - pip: tilt_pitch_pip
