#!/bin/bash

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

echo "2" > /usr/local/status

log "Starting gateway configuration"

log "Cleaning before gateway"
sudo /usr/local/bin/cleaning.sh


sudo rfkill unblock wifi; sudo rfkill unblock all

sudo cp /usr/local/templates/gateway/start-batman-adv.sh /home/rpi/start-batman-adv.sh
chmod +x /home/rpi/start-batman-adv.sh

sudo cp /usr/local/templates/gateway/dnsmasq.conf /etc/dnsmasq.conf

sudo systemctl restart dnsmasq.service

sudo cp /usr/local/templates/gateway/dhcpcd.conf /etc/dhcpcd.conf
sudo systemctl restart dhcpcd.service

sudo systemctl start delroute
sudo systemctl stop wifisignal.service


/home/rpi/start-batman-adv.sh

espeak "Ready as a gateway"
# echo "Prêt en tant que gateway" | espeak -v fr