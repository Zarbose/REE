#!/bin/bash -u

logger "**********bloquerMac = ($1)**************"

# Chemin du fichier de configuration dnsmasq
CONFIG_FILE="/etc/dnsmasq.conf"

# Tableau pour stocker les adresses MAC à bloquer
#MACS_TO_BLOCK=("$@")
MAC=$1

# Vérifier si des adresses MAC ont été passées en paramètre
#if [ $@ -eq 0 ]; then
#    logger "Aucune adresse MAC spécifiée. Le script prend en paramètre les adresses MAC à bloquer."
 #   exit 1
#fi

# Supprimer les anciennes règles de blocage
sed -i '/^dhcp-host=.*ignore/d' $CONFIG_FILE

# Ajouter les nouvelles règles de blocage
#for mac_address in "${MACS_TO_BLOCK[@]}"; do
    echo "dhcp-host=$MAC,ignore" >> $CONFIG_FILE
    logger "------MAC ($MAC)------ bloqué"
#done

# Redémarrer dnsmasq pour appliquer les changements
#systemctl restart dnsmasq
systemctl restart hostapd.service dnsmasq.service

logger "dnsmasq redémarré"

