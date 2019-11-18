#!/bin/bash
/usr/local/bin/mcrcon -H 127.0.0.1 -p {{ minecraft.rcon_pass }} "say Saving world, beware of lag..." 
sleep 2
/usr/local/bin/mcrcon -H 127.0.0.1 -p {{ minecraft.rcon_pass }} save-all
/usr/local/bin/mcrcon -H 127.0.0.1 -p {{ minecraft.rcon_pass }} save-off
