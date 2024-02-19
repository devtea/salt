nginx
=====

containerd.sls
--------------

If the service port on the backend is expecting https, set "backend_https" to true in the containerd pillar service dict
e.g.:

```yaml
containerd:
  services_conf:
    heimdall:
      port: 8443
      domain: heimdall.example.com
      backend_https: True
```
