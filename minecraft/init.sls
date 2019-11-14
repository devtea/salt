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

