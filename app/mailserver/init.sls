{% from "app/mailserver/map.jinja" import mailserver with context %}

include:
  - postfix

extend:
  postfix_maincf:
    file.managed:
      - name: /etc/postfix/main.cf
      - source: salt://app/mailserver/files/main.cf
      - template: jinja
      - context:
          mailserver: {{ mailserver | tojson }}
      - require:
        - pkg: postfix_pkg


postfix_virtual_alias_maps:
  file.managed:
    - name: /etc/postfix/virtual
    - source: salt://app/mailserver/files/virtual
    - template: jinja
    - context: 
        mailserver: {{ mailserver | tojson }}

postfix_reload_lookup_table:
  cmd.run: 
    - name: "postmap /etc/postfix/virtual"
    - onchanges: 
      - file: postfix_virtual_alias_maps

postfix_25_iptables:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - dport: 25
    - protocol: tcp
    - save: True
