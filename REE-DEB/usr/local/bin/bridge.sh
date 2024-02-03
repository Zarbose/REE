#!/bin/bash

log "Starting bridge configuration"

sudo cp /usr/local/templates/bridge/eth /etc/network/interfaces.d/eth

sudo cp /usr/local/templates/bridge/dhcpcd.conf /etc/dhcpcd.conf

sudo cp /usr/local/templates/bridge/start-batman-adv.sh /home/rpi/start-batman-adv.sh
chmod +x /home/rpi/start-batman-adv.sh

sudo systemctl restart dhcpcd.service


/home/rpi/start-batman-adv.sh


espeak "Ready as a bridge"