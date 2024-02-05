#!/bin/bash

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

while (cat /sys/class/net/eth0/carrier | grep -q "0");
do
    sleep 1
done

pid=$(ps aux | grep "isgateway" | awk '{print $2}')
sudo kill -9 $pid

log "isbridge : start bridge configuration"

/usr/local/bin/bridge.sh