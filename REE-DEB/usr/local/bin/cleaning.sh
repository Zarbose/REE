#!/bin/bash

LOG_FILE="/var/log/REE.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log "Clean : interface down"
sudo ifconfig wlan0 down
sudo ifconfig bat0 down
sudo ifconfig br0 down

#systemctl stop dhcpcd.service

log "Clean : copy files"
cat /usr/local/default/dhcpcd.conf > /etc/dhcpcd.conf
cat /usr/local/default/dnsmasq.conf > /etc/dnsmasq.conf

sudo rm /etc/network/interfaces.d/eth

log "Clean : reset ip bat0"
sudo ip addr flush dev bat0
log "Clean : remove bat0"
sudo batctl meshif bat0 interface destroy
sudo batctl if del wlan0
log "Clean : remove br0"
sudo brctl delbr br0
sudo iptables -F

log "Clean : restart dhcpcd"
systemctl restart dhcpcd.service
log "Fin cleaning"