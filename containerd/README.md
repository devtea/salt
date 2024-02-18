Containerd
==========

Initially designed for Archlinux

Configuration
-------------

Add `containerd` to the `app` grain, and a list of services to `containerd:services`. Each service name
must match a service compose file in `salt://containerd/files/services` with associated values in the pillar.