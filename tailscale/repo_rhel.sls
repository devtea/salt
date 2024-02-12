tailscale_repo:
  pkgrepo.managed:
    - humanname: Tailscale
    - name: tailscale-stable
    - baseurl: https://pkgs.tailscale.com/stable/centos/$releasever/$basearch
    - enabled: 1
    - repo_gpgcheck: 1
    - gpgcheck: 0
    - gpgkey: https://pkgs.tailscale.com/stable/centos/$releasever/repo.gpg
    - require_in:
      - pkg: tailscale_pkg