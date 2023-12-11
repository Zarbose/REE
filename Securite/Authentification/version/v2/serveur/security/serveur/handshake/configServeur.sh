#!/bin/bash -u
logger -e "############################ Service de configuration client serveur a été lancer ##############################"
# Obtenir le chemin absolu du répertoire du script principal

script_dir=$(dirname "$(readlink -f "$0")")

config="$script_dir/config"

# Récupérer les lignes contenant "wlan0" et "C" dans la table ARP
arp_lines=$(arp -n | grep wlan0 | grep C)

# Récupérer l'adresse IP et la passerelle en utilisant awk
client=$(echo "$arp_lines" | awk '{print $1}')
ip_address=$(hostname -I | awk '{print $2}')

# Afficher les résultats
logger -e  "************************* Adresse IP du serveur: $ip_address **************************"
logger -e "************************* Adresse IP du Client : $client ******************************"

# Mettre à jour le fichier de configuration avec les nouvelles adresses
sed -i "s/SERVEUR=.*/SERVEUR=$ip_address:32000/" $config
sed -i "s/CLIENT=.*/CLIENT=$client:32001/" $config

logger -e "##################### configuration du client et serveur terminer ########################"
