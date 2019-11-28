pacman_contrib_scripts:
  pkg.installed:
    - name: pacman-contrib

pacman_cleanup_hook_install:
  file.managed:
    - name: /etc/pacman.d/hooks/cache_cleanup_install.hook
    - source: salt://pacman/files/cache_cleanup_install.hook
    - makedirs: True

pacman_cleanup_hook_uninstall:
  file.managed:
    - name: /etc/pacman.d/hooks/cache_cleanup_uninstall.hook
    - source: salt://pacman/files/cache_cleanup_uninstall.hook
    - makedirs: True
