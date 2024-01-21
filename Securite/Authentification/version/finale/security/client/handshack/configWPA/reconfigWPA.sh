#!/bin/bash -u

logger -e "####################### Service de reconfiguration du WPA lancé #############################"

# Obtenir le chemin absolu du répertoire du script principal
script_dir=$(dirname "$(readlink -f "$0")")

# Chemin vers le fichier de configuration wpa_supplicant
fichier_conf="/etc/wpa_supplicant/wpa_supplicant-wlan1.conf"



while true; do

    # Mot de passe échangé

     mdp="$script_dir/configWPA/mdp/mdp.txt"

    # Vérifier si le fichier existe et n'est pas vide

    if [ -s "$mdp" ]; then

        # Nouveau mot de passe WPA_supplicant
        nouveau_psk=$(cat "$mdp")
        echo "New password: $nouveau_psk"

        # Modification du mot de passe dans le fichier de configuration
        sed -i "s/psk=.*/psk=\"$nouveau_psk\"/" "$fichier_conf"

        # Redémarrage du service wpa_supplicant
        systemctl restart networking.service 

        # Sortir de la boucle
        break
    else

logger -e "*************** Le fichier $mdp n'existe pas ou est vide. Attente... *****************"

        sleep 1  # Attendre 1 seconde avant de vérifier à nouveau
    fi
done

dhclient wlan1

logger -e "************* WPA refonfiguré et le service redémarré avec succès. ************************"

logger -e "#################  Reconfiguration du WPA est terminé #################"

