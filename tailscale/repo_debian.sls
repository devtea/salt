tailscale_prereqs:
  pkg.installed:
    - name: apt-transport-https

tailscale_repo:
  pkgrepo.managed:
    - humanname: "Tailscale Repo"
    - name: "deb https://pkgs.tailscale.com/stable/raspbian buster main"
    - key_url: "https://pkgs.tailscale.com/stable/raspbian/buster.gpg"
    - gpgcheck: 1
    - file: /etc/apt/sources.list.d/tailscale.list