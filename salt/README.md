Saltstack
=========

gpg pillar
----------

### First time setup

As root:

```bash
# Make dir
dnf install pinentry
mkdir /etc/salt/gpgkeys
chmod 0700 /etc/salt/gpgkeys
chown salt:salt /etc/salt/gpgkeys
```

As salt:

```bash
gpg --homedir /etc/salt/gpgkeys --gen-key
gpg --homedir /etc/salt/gpgkeys --list-secret-keys
gpg --homedir /etc/salt/gpgkeys --armor --export saltstack > exported_pubkey.asc
gpg --import exported_pubkey.asc
```

### Importing the pubkey for generating encrypted secrets locally

The pubkey can (naturally) be imported to any gpg keychain so you can encrypt pillar
payloads locally.

```bash
gpg --import exported_pubkey.asc
```

### Encrypting a string

```bash
echo -n 'foo' | gpg --trust-model always -ear saltstack
```
