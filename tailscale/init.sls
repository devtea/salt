tailscale_pkg:
  pkg.installed:
    - name: tailscale
    - require: 
      - pkgrepo: tailscale_repo

tailscale_service:
  service.running:
    - name: tailscaled
    - enable: True
    - require: 
      - pkg: tailscale_pkg

# if the tailscale:authed grain is not set, then we need to auth
{% if not grains['tailscale'] is defined or not grains['tailscale']['authed'] is defined or not grains['tailscale']['authed'] %}
tailscale_auth:
  cmd.run:
    - name: tailscale up --authkey {{ pillar['common']['tailscale']['key'] }}
    - unless: tailscale status
    - require: 
      - service: tailscale_service

tailscale_authed_grain:
  grains.present:
    - name: tailscale:authed
    - value: True
    - require: 
      - cmd: tailscale_auth
{% endif %}