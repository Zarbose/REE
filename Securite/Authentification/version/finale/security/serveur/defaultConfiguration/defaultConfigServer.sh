#!/bin/bash -u
logger -e "########################## Service de configuration par défaut du wifi et du dnsmasq est lancé ########################"

# Obtenir le chemin absolu du répertoire du script principal
script_dir=$(dirname "$(readlink -f "$0")")

# Chemin vers le fichier de configuration Hostapd
fichier_conf="/etc/hostapd/hostapd.conf"

config_file="/etc/dnsmasq.conf"

script_line="dhcp-script=/srv/security/serveur/defaultConfiguration/scriptDiscoveryDefault.sh"

        # mot de passe par défaut WPA-PSK
        default_password=123456789
        echo "Defaut password: $default_password"

        # Modification du mot de passe dans le fichier de configuration
        sudo sed -i "s/wpa_passphrase=.*/wpa_passphrase=$default_password/" "$fichier_conf"

# DNS

# Vérifier si la ligne dhcp-script existe déjà dans le fichier de configuration

 sed -i '/^dhcp-script/d' "$config_file" 
   logger "La ligne existante dhcp-script a été supprimée."

 sed -i '/^dhcp-host/d' "$config_file" 
   logger "La ligne existante dhcp-host a été supprimée."


# Ajouter la nouvelle ligne à la configuration

echo "$script_line" >> "$config_file"

logger "La ligne ($script_line) a été ajoutée à la configuration dnsmasq."

systemctl restart dnsmasq.service 

 # Redémarrage du service Hostapd et dnsmasq

        sudo systemctl restart hostapd.service dnsmasq.service 

logger -e "******************Le Hostapd a été reconfigurér avec le mot de passe par défaut ($default_password) et service redémarré avec succès. ************************"

logger -e "#######################  Reconfigurationpar défaut du wifi et du dnsmasq sont terminé ######################"
