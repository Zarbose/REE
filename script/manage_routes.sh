#!/bin/bash

# Supprimer les routes ajoutés par hostapd
ip route del default via 10.0.3.254 dev wlan0 src 11.0.0.1 metric 3003
ip route del 10.0.3.254 dev wlan0 scope link src 11.0.0.1 metric 3003

# Ajouter la route souhaitée
ip route add -net 11.0.0.0 netmask 255.255.255.248 dev wlan0