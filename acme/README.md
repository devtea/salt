ACME Certificates
=================

Uses the zerossl provider with the acme.sh script for management. Defaults to 
using the cloudflare dns method for confirmation of ownership.

In general, intended to be used on minions to pull and store certs for things running
local to that minion.

Pulls certs for all domains listed in the `acme:domains` grain.

```bash
sudo salt <minion> grains.append acme:domains foo.example.com
```
