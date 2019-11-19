{% from "minecraft/map.jinja" import minecraft with context %}
minecraft_user:
  user.present:
    - name: minecraft
    - shell: /usr/bin/nologin
    - home: /srv/minecraft
    - enforce_password: true
    - password: '!!'

minecraft_spigot_build_file:
  file.directory:
    - name: /srv/minecraft/spigot_build/
    - user: minecraft
    - group: minecraft

minecraft_spigot_buildtools:
  file.managed:
    - name: /srv/minecraft/spigot_build/BuildTools.jar
    - source: {{ minecraft.spigot_url }}
    - makedirs: true
    - skip_verify: True
    - user: minecraft
    - group: minecraft
    - require: 
      - file: minecraft_spigot_build_file
      - user: minecraft_user

minecraft_spigot_build:
  file.managed:
    - name: /srv/minecraft/build_spigot.sh
    - source: salt://minecraft/files/build_spigot.sh
    - template: jinja
    - context: 
      minecraft: {{ minecraft | tojson }}
    - user: minecraft
    - group: minecraft
    - mode: 775
  cmd.script:
    - name: /srv/minecraft/build_spigot.sh
    - runas: minecraft
    - creates: /srv/minecraft/.build_script_flag
    - require:
      - file: minecraft_spigot_buildtools
      - file: minecraft_spigot_build

# Restore latest backup if it exists when this is a new server
minecraft_restore_from_backup:
  file.managed:
    - name: /srv/minecraft/restore.sh
    - source: salt://minecraft/files/restore.sh
    - mode: 775
    - user: minecraft
    - group: minecraft
  cmd.run:
    - name: /srv/minecraft/restore.sh
    - runas: minecraft
    - creates: /home/minecraft/.restore_script_flag
    - onchanges:
      - user: minecraft_user
    - require: 
      - file: minecraft_restore_from_backup
    - require_in: 
      - service: minecraft_service

minecraft_service_file:
  file.managed:
    - name: /etc/systemd/system/minecraft.service
    - source: salt://minecraft/files/minecraft.service
    - template: jinja
    - context: 
      minecraft: {{ minecraft | tojson }}
    - require:
      - file: minecraft_spigot_build
    - watch_in:
      - service: minecraft_service

minecraft_eula:
  file.managed:
    - name: /srv/minecraft/eula.txt
    - user: minecraft
    - group: minecraft
    - contents: "eula=true"
    - require_in:
      - service: minecraft_service

minecraft_server_properties:
  file.managed:
    - name: /srv/minecraft/server.properties
    - source: salt://minecraft/files/server.properties
    - user: minecraft
    - group: minecraft
    - template: jinja
    - context: 
      minecraft: {{ minecraft | tojson }}
    - require_in:
      - service: minecraft_service

minecraft_dynmap_jar:
  file.managed:
    - name: /vagrant/dynmap.jar
    - source: {{ minecraft.dynmap_url }}
    - source_hash: 1f4ba568044355e8b0c9f9095048f54e06a38f141b91b0454b75c9381378f67e

minecraft_spigot_plugins_dir:
  file.directory:
    - name: /srv/minecraft/plugins
    - user: minecraft
    - group: minecraft
    - mode: 775

minecraft_dynmap_jar_deploy:
  file.copy:
    - name: /srv/minecraft/plugins/dynmap.jar
    - source: /vagrant/dynmap.jar
    - makedirs: true
    - user: minecraft
    - group: minecraft
    - mode: 664
    - require: 
      - file: minecraft_spigot_plugins_dir
    - require_in:
      - service: minecraft_service

minecraft_service:
  service.running:
    - name: minecraft

minecraft_rcon_tar:
  file.managed: 
    - name: /vagrant/mcrcon-0.0.5-linux-x86-64.tar.gz
    - source: https://github.com/Tiiffi/mcrcon/releases/download/v0.0.5/mcrcon-0.0.5-linux-x86-64.tar.gz
    - source_hash: 5e7d9a562a736c5ca4ee174ec33869687df439889637f9457103d6a5e830a538

minecraft_rcon_extract:
  archive.extracted:
    - name: /usr/local/bin
    - source: /vagrant/mcrcon-0.0.5-linux-x86-64.tar.gz
    - if_missing: /usr/local/bin/mcrcon
    - enforce_toplevel: False


#######################
#       Timers        #
#######################
# Requires that three files exist and named for the timer
# files/NAME.timer
# files/NAME.service
# files/NAME.sh
{% for timer in ["save-server", "backup-server"] %}
timer_{{ timer }}_script:
  file.managed:
    - name: /etc/systemd/system/{{ timer }}.sh
    - source: salt://minecraft/files/{{ timer }}.sh
    - template: jinja
    - mode: 755
    - context: 
      minecraft: {{ minecraft | tojson }}

timer_{{ timer }}_service:
  file.managed:
    - name: /etc/systemd/system/{{ timer }}.service
    - source: salt://minecraft/files/{{ timer }}.service
    - template: jinja
    - context: 
      minecraft: {{ minecraft | tojson }}
    - onchanges_in:
      - cmd: minecraft_systemd_reload_daemon

timer_{{ timer }}_timer:
  file.managed:
    - name: /etc/systemd/system/{{ timer }}.timer
    - source: salt://minecraft/files/{{ timer }}.timer
    - template: jinja
    - context: 
      minecraft: {{ minecraft | tojson }}
    - require:
      - file: timer_{{ timer }}_script
      - file: timer_{{ timer }}_service
    - onchanges_in:
      - cmd: minecraft_systemd_reload_daemon

timer_{{ timer }}_enable:
  cmd.run:
    - name: 'systemctl enable {{ timer }}.timer'
    - creates: /etc/systemd/syste/timers.target.wants/{{ timer }}.timer
    - onchanges:
      - file: timer_{{ timer }}_timer

timer_{{ timer }}_start:
  cmd.run:
    - name: 'systemctl start {{ timer }}.timer'
    - onchanges:
      - file: timer_{{ timer }}_timer
    - require:
      - service: minecraft_service
      - archive: minecraft_rcon_extract
      - cmd: minecraft_restore_from_backup

{% endfor %}

minecraft_systemd_reload_daemon:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: minecraft_service_file

minecraft_server_icon:
  file.copy:
    - name: /srv/minecraft/server-icon.png
    - source: /vagrant/server-icon.png
    - user: minecraft
    - group: minecraft
    - mode: 664

minecraft_console_helper:
  file.managed:
    - name: /usr/local/bin/mc_run
    - mode: 755
    - contents:
      - "#!/bin/bash"
      - /usr/local/bin/mcrcon -H 127.0.0.1 -p "{{ minecraft.rcon_pass }}" "$*"


