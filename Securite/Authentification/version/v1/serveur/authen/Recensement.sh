#!/bin/bash -u

logger "########################## Recensement ###########################"


fichier="/srv/empreinte/registre/registre.txt"
fichierExp="/srv/empreinte/registre/exp/registre.txt"
fichierNum="/srv/empreinte/number.txt "
key_rsa_rasp="/home/rasp/.ssh/id_rsa"

#récupération des paramètre
IP=$1

# Vérifier si le fichier n'existe pas
if [ ! -e "$fichier" ]; then

	logger "******* (AgentRecensement.sh) ************ Création du fichier resgistre **************"

	touch /srv/empreinte/registre/registre.txt

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
	# scp -i "$key_rsa_rasp" "$fichierExp" "rasp@$IP:$fichier"
sudo scp -i /home/rasp/.ssh/id_rsa /srv/empreinte/registre/exp/registre.txt  rasp@10.0.1.105:/srv/empreinte/registre/registre.txt

 logger "******************* Le registre a été envoyé au client avec succès. *****************************"

logger "####################### Recensement terminé ###########################"
