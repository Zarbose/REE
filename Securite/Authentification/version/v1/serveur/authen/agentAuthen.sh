#!/bin/bash


# Obtenir le chemin absolu du répertoire du script principal

script_dir=$(dirname "$(readlink -f "$0")")

#configuration de l'adresse ip du client et du serveur
#configScript="$script_dir/configServeur.sh"

# Variables pour les chemins
auth_file="/srv/empreinte/auth.txt"
result_file="/srv/empreinte/resultEmptreinte.txt"
registre_file="/srv/empreinte/registre/registre.txt"
mac_blocklist="/home/odiouma/authen/mac_blocklist.txt"
bloquer_mac_script="/home/odiouma/authen/bloquerMac.sh"
recenser="/home/odiouma/authen/Recensement.sh"
IP=$1
MAC=$2

# Logger
log() {
    logger "$1"
    echo "$1"
}

# Fonction pour normaliser une chaîne
normalize_string() {
    echo "$1" | tr -d '[:space:]' | dos2unix
}

# Créer les répertoires nécessaires
mkdir -p /srv/empreinte/registre
mkdir -p /home/odiouma/authen

# Début du script
log "#################### agentAuth ###################### params = ($@)"

# Création du fichier auth.txt
echo "auth" > "$auth_file"

# Copie du fichier resultEmptreinte.txt depuis le serveur
scp "rasp@$IP:$result_file" "$result_file"
sleep 2

# Extraction de l'empreinte destination
dest=$(grep "$IP" "$result_file" | cut -d ":" -f2)

# Extraction de l'empreinte de la machine locale (uname -a | sha256sum)
exp=$(uname -a | sha256sum)

# Debug
log "Dest = $dest"
log "Exp = $exp"
# Fin du debug

# Normalisation des empreintes
empreinteDest=$(normalize_string "$dest")
empreinteExp=$(normalize_string "$exp")

# Debug
log "empreinteDest = $empreinteDest"
log "empreinteExp = $empreinteExp"
# Fin du debug

# Comparaison des empreintes
if [ "$empreinteDest" == "$empreinteExp" ]; then
    log "Les empreintes sont égales."
    log "recenser = $recenser sleep 10"
sleep 10
     source "$recenser" "$IP"

else
    log "Les empreintes ne sont pas égales."
    sudo iptables -A INPUT -s "$IP" -j DROP
    log "Ip = $IP a été bloquée avec succès"
    source "$bloquer_mac_script" "$MAC"
    log "MAC ($MAC) a été bloquée."
fi

# Attendre 6 secondes
sleep 6

# Débloquer l'IP si les empreintes ne sont toujours pas égales
if [ "$empreinteDest" != "$empreinteExp" ]; then
    sudo iptables -D INPUT -s "$IP" -j DROP
    log "IP = $IP a été débloquée avec succès après 6 secondes."
fi
