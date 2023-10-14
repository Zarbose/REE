#!/bin/bash

SUBNET="192.168.1.0/24" #à adapter

#script that modify all files to update the configuration

echo "Recherche de Raspberry Pi dans le réseau..."
raspberry_ips=$(nmap -sn $SUBNET | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

#faire en sorte de se connecter en root ou modifier les droits des fichiers qui doivent être modifer pour que l'installation du paquet soit possible
for ip in $raspberry_ips; do
    echo "Connexion à $ip..."
    
    ssh pi@$ip "curl -L --output paquetDeb.deb https://github.com/Zarbose/REE/releases/latest/download/REE-DEB.deb && dpkg -i paquetDeb.deb && echo 'Installation terminé' "

    echo "Configuration terminée pour $ip"
done

echo "Tous les Raspberry Pi ont été configurés."
