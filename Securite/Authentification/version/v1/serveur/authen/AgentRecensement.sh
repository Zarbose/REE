#!/bin/bash
logger "************(AgentRecensement.sh)***************Création du fichier resgistre ****************************************"

touch /srv/empreinte/registre/registre.txt

fichier="/srv/empreinte/registre/registre.txt"


for ((i=1; i<=20;i++));do
	echo $i >>$fichier
done

