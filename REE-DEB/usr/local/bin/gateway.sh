#!/bin/bash

log "Starting gateway configuration"


sudo rfkill unblock wifi; sudo rfkill unblock all

sudo cp /usr/local/templates/gateway/start-batman-adv.sh /home/rpi/start-batman-adv.sh
chmod +x /home/rpi/start-batman-adv.sh

sudo cp /usr/local/templates/gateway/dnsmasq.conf /etc/dnsmasq.conf

sudo systemctl restart dnsmasq.service

/home/rpi/start-batman-adv.sh

espeak "Ready as a gateway"