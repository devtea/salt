#!/bin/bash

# WIP not ready for use yet

iptables -F
iptables -X
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 9022 -j ACCEPT
iptables -P INPUT DROP

wget -O bootstrap-salt.sh https://bootstrap.saltstack.com
sha256sum ./bootstrap-salt.sh
chmod +x ./bootstrap-salt.sh
./bootstrap-salt.sh -x python3 stable 2019.2

# lay down minion file
tee /etc/salt/minion <<END
file_client: local
file_roots:
  base:
    - /srv/salt/states/
pillar_roots:
  base:
    - /srv/salt/pillar/
END

systemctl restart salt-minion
systemctl enable salt-minion

mkdir -p /srv/salt/{states,pillar}/

