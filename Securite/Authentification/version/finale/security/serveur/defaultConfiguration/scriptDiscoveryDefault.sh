#!/bin/bash -u

logger "Le script scriptDiscoveryDefault.sh est lancé !"

# Obtenir le chemin absolu du répertoire du script principal

script_dir=$(dirname "$(readlink -f "$0")")

defaultConfig="/srv/security/serveur/handshake/serveur.sh"
# affectation des paramètres
action="$1"
ip="$3"
mac="$2"

# gestion des actions reçue

case "$action" in
    "add")
	logger "L'appareil avec IP ($ip) et MAC ($mac) a obtenu un bail DHCP." 
        echo "L'appareil avec IP ($ip) et MAC ($mac) a obtenu un bail DHCP." >> clientsConnecter.txt
	#source $defaultConfig
	logger "(add)le script defaultConfigServer.sh a été lancer avec comme paramètre $ip"
        source "$defaultConfig"
	;;
    "old")
	logger "L'appareil avec IP ($ip) et MAC ($mac) a renouvelé son bail DHCP."
        echo "L'appareil avec IP ($ip) et MAC ($mac) a renouvelé son bail DHCP." >> clientsConnecter.txt
	#source $defaultConfig
	logger "(old)le script defaultConfigServer.sh a été lancer avec comme paramètre $ip"
        source "$defaultConfig"
	 ;;
    "del")
	logger "L'appareil avec IP ($ip) et MAC ($mac) a libéré son bail DHCP."	
        echo "L'appareil avec IP ($ip) et MAC ($mac) a libéré son bail DHCP." >> clientsDeconnecter.txt
        ;;
    *)
	logger "Action inconnue : $action "
        echo "Action inconnue : $action" >> error.txt
        ;;
esac
