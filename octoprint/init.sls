octo_user:
  user.present:
    - name: octo
    - groups:
      - uucp

octo_sudoers:
  file.managed:
    - name: /etc/sudoers.d/octoprint
    - source: salt://octoprint/files/octoprint.sudoers
    - mode: "0600"

octo_prereqs:
  pkg.installed:
    - pkgs:
      - python3
      - python3-venv
      - python3-setuptools
      - gcc
      # - libyaml
      - ffmpeg

octo_dir:
  file.directory:
    - name: /home/octo/octoprint/
    - user: octo
    - group: octo
    - require:
      - user: octo_user
      - pkg: octo_prereqs

# couldn't get this to work with salt's virtualenv module
octo_install:
  cmd.script:
    - name: salt://octoprint/files/setup.sh
    - creates: /home/octo/octoprint/venv/bin/octoprint
    - runas: octo
    - require:
      - file: octo_dir

octo_service_file:
  file.managed:
    - name: /etc/systemd/system/octoprint.service
    - source: salt://octoprint/files/octoprint.service
    - require:
      - file: octo_dir
      - cmd: octo_install

octo_reload:
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: octo_service_file

octo_service:
  service.running:
    - name: octoprint
    - enable: true
    - require:
      - file: octo_service_file
      - module: octo_reload
