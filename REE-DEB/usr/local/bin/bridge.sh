#!/bin/bash

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log "Starting bridge configuration"

sudo cp /usr/local/templates/bridge/eth /etc/network/interfaces.d/eth

sudo cp /usr/local/templates/bridge/dhcpcd.conf /etc/dhcpcd.conf

sudo cp /usr/local/templates/bridge/start-batman-adv.sh /home/rpi/start-batman-adv.sh
chmod +x /home/rpi/start-batman-adv.sh

sudo systemctl restart dhcpcd.service


/home/rpi/start-batman-adv.sh


espeak "Ready as a bridge"