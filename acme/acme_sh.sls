{% from "acme/map.jinja" import acme with context %}
{% from "common/map.jinja" import common with context %}
# Using acme.sh project for ACME client 
# https://github.com/acmesh-official/acme.sh

acme_sh_git_dir:
  file.directory:
    - name: "/home/{{ common.primary_user.username }}/acme.sh"
    - user: {{ common.primary_user.username }}
    - group: {{ common.primary_user.username }}
    - mode: "0755"

acme_sh_git:
  git.latest:
    - name: https://github.com/acmesh-official/acme.sh.git
    - target: "/home/{{ common.primary_user.username }}/acme.sh/"
    - rev: "{{ acme.tag }}"
    - user: {{ common.primary_user.username }}
    - force_checkout: True
    - force_fetch: True
    - fetch_tags: True
    - sync_tags: True
    - depth: 1
    - require:
      - file: acme_sh_git_dir

acme_sh_install:
  cmd.run:
    - name: /home/{{ common.primary_user.username }}/acme.sh/acme.sh --install
    - user: {{ common.primary_user.username }}
    - cwd: "/home/{{ common.primary_user.username }}/acme.sh/"
    #- creates: /home/{{ common.primary_user.username }}/.acme.sh/account.conf
    - onchanges:
      - git: acme_sh_git

{% for domain in acme["domains"] %}

# register zerossl EAB
acme_sh_register_{{ domain }}:
  cmd.run: 
    - name: >
        /home/{{ common.primary_user.username }}/acme.sh/acme.sh
        --register-account
        --server {{ acme.server }}
        --eab-kid {{ acme.eab_kid }}
        --eab-hmac-key {{ acme.eab_hmac_key }}
    - user: {{ common.primary_user.username }}
    - creates: /home/{{ common.primary_user.username }}/.acme.sh/ca
    - require:
      - cmd: acme_sh_install

acme_sh_issue_{{ domain }}:
  cmd.run:
    - name: >
        /home/{{ common.primary_user.username }}/acme.sh/acme.sh
        --server {{ acme.server }}
        --issue
        -d {{ domain }}
        --dns dns_cf
    - user: {{ common.primary_user.username }}
    - env:
      - CF_Token: {{ acme.cf_token }}
      - CF_Account_ID: {{ acme.cf_account_id }}
    - creates: /home/{{ common.primary_user.username }}/.acme.sh/{{ domain }}_ecc/
    - require:
      - cmd: acme_sh_register_{{ domain }}

{% endfor %}