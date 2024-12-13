{% from "common/map.jinja" import common with context %}

arch_packages:
  pkg.installed:
    - names: 
      - base-devel
      - neovim
      - {{ common.packages.python_neovim }}

# Remove the well known default users
{% for user in ['alarm', 'pi'] %}
{{ user }}_cleanup:
  user.absent:
    - name: {{ user }}
    - purge: True
{% endfor %}

# template prep script
arch_template_prep_script:
  file.managed:
    - name: /usr/local/sbin/arch_template_prep.sh
    - source: salt://common/files/arch_template_prep.sh
    - user: root
    - group: root
    - mode: '0755'

# aur build directory
aur_build_dir:
  file.directory:
    - name: /home/{{ common.primary_user.username }}/build/
    - user: {{ common.primary_user.username }}
    - group: {{ common.primary_user.group }}
    - mode: '0755'

