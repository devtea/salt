selinux_packages:
  pkg.installed:
      - policycoreutils
      - policycoreutils-python-utils
      - selinux-policy

selinux_enforce:
  selinux.mode:
    - name: enforcing