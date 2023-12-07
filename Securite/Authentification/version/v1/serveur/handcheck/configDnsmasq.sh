#!/bin/bash

logger "################# configDnsmasq #####################"
config_file="/etc/dnsmasq.conf"
script_line="dhcp-script=/etc/scriptDHCP/scriptDiscovery.sh"

# Vérifier si la ligne dhcp-script existe déjà dans le fichier de configuration
#if grep -q "^$script_line" "$config_file"; then
    # La ligne existe, la supprimer
    #sed -i "/^$script_line/d" "$config_file"
    sed -i '/^dhcp-script/d' "$config_file" 
   logger "La ligne existante a été supprimée."
#fi

# Ajouter la nouvelle ligne à la configuration
echo "$script_line" >> "$config_file"
logger "La ligne ($script_line) a été ajoutée à la configuration dnsmasq."
systemctl restart dnsmasq.service 
logger "################ configuration du dnsmasq terminé #############"
