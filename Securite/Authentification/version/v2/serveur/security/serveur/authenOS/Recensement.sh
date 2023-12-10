#!/bin/bash -u

logger "########################## Recensement ###########################"

#création des repertoires nécessaire
mkdir -p /srv/security/registre
mkdir -p /srv/security/registre/exp


#chemin des fichiers 
fichier="/srv/security/registre/registre.txt"
fichierExp="/srv/security/registre/exp/registre.txt"
fichierNum="/srv/security/registre/number.txt "
key_rsa_rasp="/home/rasp/.ssh/id_rsa"

#récupération des paramètre
IP=$1

# Vérifier si le fichier n'existe pas
if [ ! -e "$fichier" ]; then

	logger "******* (AgentRecensement.sh) ************ Création du fichier resgistre **************"

	for ((i=1; i<=20;i++));do
        	echo $i >>$fichier
	done
fi
    # Récupérer la première ligne
    logger "******************* Récupération du numéro qui est sur la prémière ligne ****************"

    num=$(head -n 1 "$fichier")
    echo "$num" > $fichierNum
    logger "******************** Le numéro a été récupéré avec succès. *************************"

    # Supprimer la première ligne
    tail -n +2 "$fichier" > "$fichierExp"
    logger "******************* Le fichier à expédier a été créé avec succès. *****************************"

    # Envoi du registre au client
	 scp -i "$key_rsa_rasp" "$fichierExp" "rasp@$IP:$fichier"

logger "******************* Le registre a été envoyé au client avec succès. *****************************"

logger "####################### Recensement terminé ###########################"
