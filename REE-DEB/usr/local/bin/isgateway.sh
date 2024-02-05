#!/bin/bash

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

while (cat /sys/class/net/usb0/carrier | grep -q "0");
do
    sleep 1
done

pid=$(ps aux | grep "isbridge" | awk '{print $2}')
sudo kill -9 $pid

log "isgateway : start gateway configuration"

/usr/local/bin/gateway.sh