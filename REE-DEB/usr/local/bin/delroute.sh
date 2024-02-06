#!/bin/bash

LOG_FILE="/var/log/REE.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

while true; do

    sudo ip route del default via 192.168.199.1 dev bat0

    sleep 15
done