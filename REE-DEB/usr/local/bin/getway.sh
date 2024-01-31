#!/bin/bash

sudo cp /usr/local/templates/gateway/start-batman-adv.sh ~/start-batman-adv.sh
chmod +x ~/start-batman-adv.sh

sudo cp /usr/local/templates/gateway/dnsmasq.conf /etc/dnsmasq.conf

~/start-batman-adv.sh