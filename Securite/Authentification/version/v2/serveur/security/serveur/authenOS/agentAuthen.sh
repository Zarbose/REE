#!/bin/bash -u 

# Obtenir le chemin absolu du répertoire du script principal
script_dir=$(dirname "$(readlink -f "$0")")
# scp rasp@10.0.1.105: /srv/security/empreinte/resultEmptreinte.txt /srv/security/empreinte/client/EmptreinteClient.txt
# Créer les répertoires nécessaires
mkdir -p /srv/security/empreinte
mkdir -p /srv/security/empreinte/client
mkdir -p /srv/security/registre

# Variables pour les chemins

result_file="/srv/security/empreinte/resultEmptreinte.txt"
empreinte_client="/srv/security/empreinte/client/EmptreinteClient.txt"
registre_file="/srv/security/registre/registre.txt"
bloquer_mac_script="$script_dir/bloquerMac.sh"
recenser="$script_dir/Recensement.sh"

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

# Début du script
log "#################### agentAuth ###################### params = ($@)"

# Copie du fichier resultEmptreinte.txt depuis le serveur
scp "rasp@$IP:$result_file" "$empreinte_client"
sleep 2

# Extraction de l'empreinte du client
dest=$(grep "$IP" "$empreinte_client" | cut -d ":" -f2)

# Extraction de l'empreinte de la machine locale (uname -a | sha256sum)
exp=$(uname -a | sha256sum)

# Debug
log "empreinte client = $dest"
log "empreinte serveur = $exp"
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
