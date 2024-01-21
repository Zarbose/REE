#!/bin/bash -u


# Obtenir le chemin absolu du répertoire du script principal

script_dir=$(dirname "$(readlink -f "$0")")

authenOS="/srv/security/serveur/authenOS/agentAuthen.sh"
# affectation des paramètres
action="$1"
ip="$3"
mac="$2"

# gestion des actions reçue

case "$action" in
    "add")
	logger "L'appareil avec IP ($ip) et MAC ($mac) a obtenu un bail DHCP." 
        echo "L'appareil avec IP ($ip) et MAC ($mac) a obtenu un bail DHCP." >> clientsConnecter.txt
	source $authenOS $ip $mac
	logger "(add)le script agentAuthen.sh a été lancer avec comme paramètre $ip"
        ;;
    "old")
	logger "L'appareil avec IP ($ip) et MAC ($mac) a renouvelé son bail DHCP."
        echo "L'appareil avec IP ($ip) et MAC ($mac) a renouvelé son bail DHCP." >> clientsConnecter.txt
	source $authenOS $ip $mac
	logger "(old)le script agentAuthen.sh a été lancer avec comme paramètre $ip"
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
