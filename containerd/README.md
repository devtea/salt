Containerd
==========

Initially designed for Archlinux

Configuration
-------------

Add `containerd` to the `app` grain, and a list of services to `containerd:services`. Each service name
must match a service compose file in `salt://containerd/files/services` with associated values in the pillar.

Each service name must set a `port` key and a `domain` key, with an optional `backend_https` key to switch the 
backend proxy connection from http (default) to https.

The port only sets the back end port for nginx and containerd to talk with. The domain drives certificate generation
and name based matching in nginx.

```yaml
containerd:
  services_conf:
    heimdall:
      port: 8443
      domain: heimdall.example.com
      backend_https: True
    my-service:
      port: 8001
      domain: foo.example.com
```
