#!/bin/bash

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

while (true);
do
    FILE=/sys/class/net/usb0/carrier
    if [ -f "$FILE" ]; then
        status=$(cat $FILE)
        if [ $status -eq 1 ]; then
            break
        fi
    fi
    sleep 1
done

pid=$(ps aux | grep "isbridge" | awk '{print $2}')
sudo kill -9 $pid

log "isgateway : start gateway configuration"

/usr/local/bin/gateway.sh