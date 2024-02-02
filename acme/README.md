ACME Certificates
=================

Uses the zerossl provider with the acme.sh script for management. Defaults to
using the cloudflare dns method for confirmation of ownership.

In general, intended to be used on minions to pull and store certs for things running
local to that minion.

Pulls certs for all domains listed in the `acme:domains` grain. Each item in the
`acme:domains` list should be a dict containing at least a "domain" key. Optional
additional keys include:

* reloadcmd - Path to a script to call when the cert is (re)issued.

Grains example:

```yaml
acme:
  domains:
    - domain: foo.example.com
      reloadcmd: "~/push_to_server.sh"
    - domain: bar.example.com
```

```bash
# Add a domain
sudo salt <minion> grains.append acme:domains '{"domain": "foo.example.com"}'

# Add a domain with a custom reloadcmd
sudo salt <minion> grains.append acme:domains \
  '{"domain": "foo.example.com", "reloadcmd": "/path/to/script.sh"}'
```
