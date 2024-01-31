#!/bin/bash
# batman-adv interface to use
sudo batctl if add wlan0
sudo ifconfig bat0 mtu 1468

sudo brctl addbr br0
sudo brctl addif br0 eth0 bat0

# Tell batman-adv this is a gateway client
sudo batctl gw_mode client

# Activates batman-adv interfaces
sudo ifconfig wlan0 up
sudo ifconfig bat0 up

# Restart DHCP now bridge and mesh network are up
sudo dhclient -r br0
sudo dhclient br0