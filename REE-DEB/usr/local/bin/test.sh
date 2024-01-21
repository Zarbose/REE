#!/bin/bash


## ECOUTER SI UN APPAREIL SE CONNECTE


etat=$(echo "Client ou serveur ?")


if [ $etat -eq 0 ]
then
    echo "Serveur donc possiblement la pi 0";
    
    # DH

    psk="test";

    echo 'interface=wlan0
    ssid=REE
    hw_mode=g
    channel=1
    macaddr_acl=0
    auth_algs=1
    #ignore_broadcast_ssid=0
    wpa=2
    wpa_passphrase='$psk'
    wpa_key_mgmt=WPA-PSK
    wpa_pairwise=TKIP
    rsn_pairwise=CCMP
    country_code=FR
    #ctrl_interface=/var/run/hostapd
    #ctrl_interface_group=0
    #daemonize /usr/local/bin/manageroutes
    ' > /etc/hostapd/hostapd.conf

    systemctl restart hostapd.service

else
    echo "Client donc pas la pi 0";

    # DH

    psk="test";
    echo 'network={
        ssid="REE"
        psk="'$psk'"
    }' > /etc/wpa_supplicant/wpa_supplicant-wlan1.conf

    systemctl restart wpa_supplicant@wlan1.service
    systemctl restart washing.service
fi