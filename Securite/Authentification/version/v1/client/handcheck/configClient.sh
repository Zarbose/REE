#!/bin/bash

logger -e "################ Service de configuration client serveur a été lancé #######################"

# Obtenir le chemin absolu du répertoire du script principal

script_dir=$(dirname "$(readlink -f "$0")")

config="$script_dir/config"

# Récupérer les lignes contenant "wlan1" et "C" dans la table ARP
arp_lines=$(arp -n | grep wlan1 | grep C)

# Récupérer l'adresse IP et la passerelle en utilisant awk
serveur=$(ip route show |grep wlan1 |awk '{print $3}' |head -n 1)

#serveur=$(echo "$arp_lines" | awk '{print $1}')

ip_address=$(hostname -I | awk '{print $2}')

ping -c4 "$serveur"

# Afficher les résultats
logger -e "****************** Adresse IP du client: $ip_address **********************"
logger -e "***************** Adresse IP du serveur : $serveur **********************"

# Mettre à jour le fichier de configuration avec les nouvelles adresses
sed -i "s/SERVEUR=.*/SERVEUR=$serveur:32000/" $config
sed -i "s/CLIENT=.*/CLIENT=$ip_address:32001/" $config

logger -e "################### configuration du client et serveur terminé ###########"

