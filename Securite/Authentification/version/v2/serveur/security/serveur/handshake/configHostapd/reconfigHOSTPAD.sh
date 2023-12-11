#!/bin/bash -u
logger -e "########################## Service de reconfiguration du wifi lancé ########################"

# Obtenir le chemin absolu du répertoire du script principal
script_dir=$(dirname "$(readlink -f "$0")")

# Chemin vers le fichier de configuration Hostapd
fichier_conf="/etc/hostapd/hostapd.conf"

while true; do
    # Fichier mot de passe

     mdp="$script_dir/configHostapd/mdp/mdp.txt"

    # Vérifier si le fichier existe et n'est pas vide
    if [ -s "$mdp" ]; then
        # Nouveau mot de passe WPA-PSK
        nouveau_mot_de_passe=$(cat "$mdp")
	echo "New password: $nouveau_mot_de_passe"

        # Modification du mot de passe dans le fichier de configuration
        sudo sed -i "s/wpa_passphrase=.*/wpa_passphrase=$nouveau_mot_de_passe/" "$fichier_conf"

        # Redémarrage du service Hostapd et dnsmasq
        sudo systemctl restart hostapd.service dnsmasq.service 

        # Sortir de la boucle
        break
    else
        logger -e "***************************** Le fichier $mdp n'existe pas ou est vide. Attente... *******************************"
        sleep 1  # Attendre 1 seconde avant de vérifier à nouveau
    fi
done

logger -e "****************** Mot de passe Hostapd modifié et service redémarré avec succès. ************************"

logger -e "#######################  Reconfiguration du wifi est terminé ######################"

