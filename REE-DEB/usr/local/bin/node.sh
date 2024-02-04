#!/bin/bash

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log "Starting node configuration"

sudo cp /usr/local/templates/node/start-batman-adv.sh /home/rpi/start-batman-adv.sh
chmod +x /home/rpi/start-batman-adv.sh

echo "1" > /usr/local/status

/home/rpi/start-batman-adv.sh

espeak "Ready as a node"
