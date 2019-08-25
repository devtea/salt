centos_packages:
  pkg.installed:
    - names: 
      - epel-release
      - policycoreutils-python

bootstrap_cleanup:
  pkg.removed:
    - name: python34

