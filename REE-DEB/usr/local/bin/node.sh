#!/bin/bash

log "Starting node configuration"

sudo cp /usr/local/templates/node/eth /etc/network/interfaces.d/eth

sudo cp /usr/local/templates/node/start-batman-adv.sh /home/rpi/start-batman-adv.sh
chmod +x /home/rpi/start-batman-adv.sh

/home/rpi/start-batman-adv.sh

espeak "Ready as a node"
