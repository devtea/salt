Containerd
==========

Initially designed for Archlinux

Configuration
-------------

Add `containerd` to the `app` grain, and a list of services to `containerd:services`. Each service name
must match a service compose file in `salt://containerd/files/services` with associated values in the pillar.

In the pillar, each service name must set a `port` key and a `domain` key, with an optional `backend_https` key to switch the
backend proxy connection from http (default) to https.

The port only sets the back end port for nginx and containerd to talk with. The domain drives certificate generation
and name based matching in nginx.

```yaml
# containerd.sls in pillar
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

### Setting up a new service outline

1. Select a service name, e.g. "foo"
2. Add the compose yaml file named `foo.yaml` to `salt://containerd/files/services/`
3. Add the service name (foo) to the `containerd:services` grain
4. Add your desired url to the `acme:domains` grain list on the host (if you need certs).
5. Add another key to the pillar `containerd:services_conf` dict in
   `containerd.sls` with the service port, domain, and any additional
   pillar values needed by the service config.
6. Commit and highstate.
7. Add a DNS entry for your new service pointed at the host to the internal DNS resolver
   (pihole) and optionally external resolver (cloudflare).
8. Add monitoring for your new service to uptime-kuma.
9. Add a link to the dashboard if desired.