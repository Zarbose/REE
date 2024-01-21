#!/bin/bash -u

logger -e "####################### Service de configuration par défaut du WPA lancé #############################"

client="/srv/security/client/handshack/client.sh"

# Chemin vers le fichier de configuration wpa_supplicant
fichier_conf="/etc/wpa_supplicant/wpa_supplicant-wlan1.conf"

        # Nouveau mot de passe WPA_supplicant
        default_password=123456789
        echo "Default password: $default_password"

        # Modification du mot de passe dans le fichier de configuration
        sed -i "s/psk=.*/psk=\"$default_password\"/" "$fichier_conf"

        # Redémarrage du service wpa_supplicant
       	 systemctl restart networking.service 

        source "$client"

       
dhclient wlan1

logger -e "************* WPA refonfiguré et le service redémarré avec succès. ************************"

logger -e "################# configuration par défaut du WPA est terminé #################"

