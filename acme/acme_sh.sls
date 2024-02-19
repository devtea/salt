{% from "acme/map.jinja" import acme with context %}
# Using acme.sh project for ACME client 
# https://github.com/acmesh-official/acme.sh

acme_sh_git_dir:
  file.directory:
    - name: "/home/{{ acme.user }}/acme.sh"
    - user: {{ acme.user }}
    - group: {{ acme.user }}
    - mode: "0755"

acme_sh_git:
  git.latest:
    - name: https://github.com/acmesh-official/acme.sh.git
    - target: "/home/{{ acme.user }}/acme.sh/"
    - rev: "{{ acme.tag }}"
    - runas: {{ acme.user }}
    - force_checkout: True
    - force_fetch: True
    - fetch_tags: True
    - sync_tags: True
    - require:
      - file: acme_sh_git_dir

# "Installing" acme.sh sets up the binary and cron job for automatic renewal
acme_sh_install:
  cmd.run:
    - name: /home/{{ acme.user }}/acme.sh/acme.sh --install
    - runas: {{ acme.user }}
    - cwd: /home/{{ acme.user }}/acme.sh/
    #- creates: /home/{{ acme.user }}/.acme.sh/account.conf
    - onchanges:
      - git: acme_sh_git

# register with the ACME server
acme_sh_register:
  cmd.run:
    - name: >
        /home/{{ acme.user }}/acme.sh/acme.sh
        --register-account
        --server {{ acme.server }}
        --eab-kid {{ acme.eab_kid }}
        --eab-hmac-key {{ acme.eab_hmac_key }}
    - runas: {{ acme.user }}
    - creates: /home/{{ acme.user }}/.acme.sh/ca
    - require:
      - cmd: acme_sh_install

{% if "domains" in acme and acme["domains"] | len > 0 %}
{% for item in acme["domains"] %}
# Issue cert for {{ item["domain"] }}
acme_sh_issue_{{ item["domain"] }}:
  cmd.run:
    - name: >
        /home/{{ acme.user }}/acme.sh/acme.sh
        --server {{ acme.server }}
        --issue
        -d {{ item["domain"] }}
        --dns dns_cf
        {%- if "reloadcmd" in item.keys() %}
        --reloadcmd "{{ item["reloadcmd"] }}"
        {%- endif %}
    - runas: {{ acme.user }}
    - env:
      - CF_Token: {{ acme.cf_token }}
      - CF_Account_ID: {{ acme.cf_account_id }}
    - creates: /home/{{ acme.user }}/.acme.sh/{{ item["domain"] }}_ecc/
    - require:
      - cmd: acme_sh_register

{% endfor %}
{% endif %}