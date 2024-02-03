#!/bin/bash

systemctl stop dhcpcd.service

cat /usr/local/default/dhcpcd.conf > /etc/dhcpcd.conf
cat /usr/local/default/dnsmasq.conf > /etc/dnsmasq.conf

sudo rm /etc/network/interfaces.d/eth

sudo ip addr flush dev bat0
sudo iptables -F

systemctl restart dhcpcd.service