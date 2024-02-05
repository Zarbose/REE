#!/bin/bash

while (cat /sys/class/net/eth0/carrier | grep -q "0");
do
    sleep 1
done

/usr/local/bin/bridge.sh