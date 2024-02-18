{% from "containerd/map.jinja" import containerd with context %}
{% from "common/map.jinja" import common with context %}

# Can't use hardened if it's enabled by default
containerd_boot_loader_override:
  file.replace:
    - name: /boot/loader/loader.conf
    - pattern: "hardened.conf$"
    - repl: "arch.conf"

containerd_pkg:
  pkg.installed:
    - pkgs:
    - containerd
    - nerdctl
    - rootlesskit
    - slirp4netns
    - cni-plugins

containerd_root:
  file.directory:
    - name: {{ containerd.container_root }}
    - user: {{ common.primary_user.username }}
    - group: {{ common.primary_user.username }}
    - mode: "0755"

# session linger
containerd_user_linger:
  cmd.run:
    - name: loginctl enable-linger {{ common.primary_user.username }}
    - onchanges:
      - file: containerd_root

containerd_controller_delegation:
  file.managed:
    - name: '/etc/systemd/system/user@.service.d'
    - contents: |
        [Service]
        Delegate=cpu cpuset io memory pids

containerd_reboot:
  module.run:
    - name: system.reboot
    - onchanges:
      - file: containerd_controller_delegation
      - file: containerd_boot_loader_override
    - order: last

containerd_rootless_setup:
  cmd.run:
    - name: /usr/bin/containerd-rootless-setuptool.sh install
    - runas: {{ common.primary_user.username }}
    - cwd: /home/{{ common.primary_user.username }}/
    - creates: /home/{{ common.primary_user.username }}/.config/systemd/user/containerd.service
    - require:
      - pkg: containerd_pkg

{% for service in containerd.services %}
{{ service }}:
  file.managed:
    - name: {{ containerd.container_root }}/{{ service }}/compose.yaml
    - source: salt://containerd/files/services/{{ service }}.yaml
    - user: {{ common.primary_user.username }}
    - group: {{ common.primary_user.username }}
    - makedirs: True
    - template: jinja
    - context:
        containerd: {{ containerd | tojson }}
        service: {{ service }}
    - require:
    - file: containerd_root

{{ service }}_data_dir:
  file.directory:
    - name: {{ containerd.container_root }}/{{ service }}/data/
    - user: {{ common.primary_user.username }}
    - group: {{ common.primary_user.username }}
    - mode: "0750"
    - require:
      - file: containerd_root

{{ service }}_up:
  cmd.run:
    - name: nerdctl compose up -d
    - runas: {{ common.primary_user.username }}
    - cwd: {{ containerd.container_root }}/{{ service }}
    - env:
        XDG_RUNTIME_DIR: /run/user/{{ common.primary_user.uid }}
    - require:
      - file: {{ service }}_data_dir
    - unless: nerdctl ps | grep -E " Up .*{{ service }}$"
    #- onchanges:
      #- file: {{ service }}
{% endfor %}
