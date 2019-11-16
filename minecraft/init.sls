{% from "minecraft/map.jinja" import minecraft with context %}
minecraft_user:
  user.present:
    - name: minecraft
    - shell: /usr/bin/nologin
    - home: /srv/minecraft
    - enforce_password: true
    - password: '!!'

minecraft_server_jar:
  file.managed:
    - name: /srv/minecraft/minecraft_server_{{ minecraft.version }}.jar
    - source: {{ minecraft.url }}
    - source_hash: {{ minecraft.hash }}
    - user: minecraft
    - group: minecraft
    - require: 
      - user: minecraft_user

minecraft_server_current:
  file.symlink:
    - name: /srv/minecraft/minecraft_server_current.jar
    - target: /srv/minecraft/minecraft_server_{{ minecraft.version }}.jar
    - user: minecraft
    - group: minecraft
    - require:
      - file: minecraft_server_jar
    - watch_in:
      - service: minecraft_service

minecraft_service_file:
  file.managed:
    - name: /etc/systemd/system/minecraft.service
    - source: salt://minecraft/files/minecraft.service
    - template: jinja
    - context: 
      minecraft: {{ minecraft | tojson }}
    - require:
      - file: minecraft_server_current
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
    - name: 'systemctl enable {{ timer }}.timer; systemctl start {{ timer }}.timer'
    - creates: /etc/systemd/syste/timers.target.wants/{{ timer }}.timer
    - onchanges:
      - file: timer_{{ timer }}_timer

{% endfor %}

minecraft_systemd_reload_daemon:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: minecraft_service_file
