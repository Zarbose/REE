#!/bin/bash

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log "Starting gateway configuration"

log "Cleaning before gateway"
sudo /usr/local/bin/cleaning.sh


sudo rfkill unblock wifi; sudo rfkill unblock all

sudo cp /usr/local/templates/gateway/start-batman-adv.sh /home/rpi/start-batman-adv.sh
chmod +x /home/rpi/start-batman-adv.sh

sudo cp /usr/local/templates/gateway/dnsmasq.conf /etc/dnsmasq.conf

sudo systemctl restart dnsmasq.service

/home/rpi/start-batman-adv.sh

espeak "Ready as a gateway"