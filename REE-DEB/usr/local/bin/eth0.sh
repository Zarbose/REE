#!/bin/sh

LOG_FILE="/var/log/REE.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

log "eth0 -> UP"
while ! (ifconfig eth0 | grep -q 'inet '); do
    sleep 1
done
ip=$(ifconfig eth0 | grep 'inet ' | awk  '{print $2}')

if echo $ip | grep -q "192.168.199"; then
    log "ETH0 UP -> bridge"
    /usr/local/bin/bridge.sh
else
    log "ETH0 UP -> Gateway"
    /usr/local/bin/gateway.sh
fi
