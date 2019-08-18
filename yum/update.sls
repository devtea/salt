yum_requirements:
  pkg.installed: 
    - name: yum-utils

update_system:
  pkg.uptodate:
    - refresh: true

# The english interpretation of "unless: needs-restarting" will be misleading.
# The needs-restarting utility returns 1 if a reboot is needed.
reboot_after_update:
  cmd.run:
    - name: shutdown -r 5
    - unless: needs-restarting -r
    - require:
      - pkg: yum_requirements
    - watch: 
      - pkg: update_system
