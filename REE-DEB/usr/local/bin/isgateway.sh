#!/bin/bash

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

while (true);
do
    status=$(cat /sys/class/net/usb0/carrier)
    if [ $status -eq 1 ]; then
        break
    fi
    sleep 1
done

pid=$(ps aux | grep "isbridge" | awk '{print $2}')
sudo kill -9 $pid

log "isgateway : start gateway configuration"

/usr/local/bin/gateway.sh