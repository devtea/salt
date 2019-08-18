postfix_pkg:
  pkg.installed:
    - name: postfix

postfix_maincf:
  file.managed:
    - name: /etc/postfix/main.cf
    - source: salt://postfix/files/main.cf
    - require:
      - pkg: postfix_pkg

postfix_mastercf:
  file.managed:
    - name: /etc/postfix/master.cf
    - source: salt://postfix/files/master.cf
    - require:
      - pkg: postfix_pkg

postfix_service:
  service.running:
    - name: postfix
    - enable: true
    - reload: true
    - require:
      - pkg: postfix_pkg
    - watch:
      - file: postfix_maincf
      - file: postfix_mastercf

