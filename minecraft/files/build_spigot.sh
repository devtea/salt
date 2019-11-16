#!/bin/bash
# This script is intended to be run by salt on initial setup
# It will look for a pre built jar in /vagrant or build
# it using the buildTools jar 
set -euo pipefail

# ensure this isn't accidetally being run as root
[ $UID -eq 0 ] && exit 7

touch /srv/minecraft/.build_script_flag

if [ -e /vagrant/spigot-*.jar ]; then
    set +u
    unset -v latest
    for file in "/vagrant"/*spigot-*.jar; do
        [[ $file -nt $latest ]] && latest=$file
    done

    # if the file exists, copy it and exit
    if ! [ -z $latest ]; then
        cp "$latest" /srv/minecraft/
        ln -sf /srv/minecraft/spigot-*.jar /srv/minecraft/spigot_current.jar
        exit 0
    fi
    set -u
else
    # build
    cd /srv/minecraft/spigot_build/
    java -jar ./BuildTools.jar
    rsync ./spigot-*.jar /vagrant/
    rsync ./spigot-*.jar /srv/minecraft/
    ln -sf /srv/minecraft/spigot*.jar /srv/minecraft/spigot_current.jar
fi
