{% from "gitlab/map.jinja" import gitlab with context %}

# Salt state for gitlab
gitlab_repo:
  pkgrepo.managed:
    - name: gitlab_gitlab-ce
    - humanname: Gitlab CE
    - baseurl: https://packages.gitlab.com/gitlab/gitlab-ce/el/$releasever/$basearch
    - gpgkey: >-
        https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey
        https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey/gitlab-gitlab-ce-3D645A26AB9FBD22.pub.gpg
    - gpgcheck: 1
    - repo_gpgcheck: 0
    - enabled: 1
    - metadata_expire: 300
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt

gitlab_pkgs:
  pkg.installed:
    - pkgs:
      - tar
      - gitlab-ce
    - require:
      - pkgrepo: gitlab_repo

gitlab_config:
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://gitlab/files/gitlab.rb
    - mode: "0600"
    - template: jinja
    - context:
        gitlab: {{ gitlab | tojson }}
    - require: 
      - pkg: gitlab_pkgs

gitlab_service:
  service.running:
    - name: gitlab-runsvdir
    - enable: True
    - require:
      - file: gitlab_config

gitlab_reconfigure:
  cmd.run:
    - name: gitlab-ctl reconfigure
    - onchanges:
      - file: gitlab_config