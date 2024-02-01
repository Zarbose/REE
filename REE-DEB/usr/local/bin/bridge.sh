#!/bin/bash

sudo cp /usr/local/templates/bridge/eth /etc/network/interfaces.d/eth

sudo cp /usr/local/templates/bridge/dhcpcd.conf /etc/dhcpcd.conf

sudo cp /usr/local/templates/bridge/start-batman-adv.sh ~/start-batman-adv.sh
chmod +x ~/start-batman-adv.sh

sudo systemctl restart dhcpcd.service


~/start-batman-adv.sh