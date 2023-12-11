#!/bin/bash
logger -e "################################# HandCkeck Serveur ########################################"
source utils.sh

#
  mkdir -p connexion/DH/DHparam
  mkdir -p connexion/DH/prive
  mkdir -p connexion/DH/publique
  mkdir -p connexion/DH/secret
  mkdir -p connexion/DH/keyClient
  mkdir -p configHostapd/mdp

# Obtenir le chemin absolu du répertoire du script principal

script_dir=$(dirname "$(readlink -f "$0")")

#configuration de l'adresse ip du client et du serveur
configScript="$script_dir/configServeur.sh"
source  $configScript

#chemin des fichiers

keyPub="connexion/DH/publique/public_key_serveur.pem"
keyClient="connexion/DH/keyClient/public_key.pem"
keyPrive="connexion/DH/prive/private_key.pem"
secret="connexion/DH/secret/shared_key.bin"
dhparam="connexion/DH/DHparam/dhparam.pem"
mdp="configHostapd/mdp/mdp.txt"



#génération de la clé privé

openssl genpkey -paramfile connexion/DH/DHparam/dhparam.pem -out connexion/DH/prive/private_key.pem
logger -e "*************** la clé privé du serveur a été généré avec succès ! ********************************"
#extraction de la clé publique
openssl pkey -in connexion/DH/prive/private_key.pem -pubout -out connexion/DH/publique/public_key_serveur.pem

logger -e "************************ la clé publique du serveur a été extrait de la clé privé avec succès ! ********************************"

# initier la connexion

result=""
logger -e "************************** établissement de la connexion avec le cleint: $CLIENT **************************" 

while [ "$result" != "AckSyn" ]; do

    logger -e "adresse client : $CLIENT"
    msg="SYN"

    #msg=$(head -n -1 $keyPub | tail -n +2 |cut -c 1-425)

    send $CLIENT "$msg" || logger -e "Erreur de transmission !" >&2

    logger -e "le serveur a envoyé le SYN et attend un message" >&2

    result=$(recv $SERVEUR || logger -e "Erreur de reception !" >&2)

    echo "result = $result"

if [ "$result" == "AckSyn" ]; then

	send $CLIENT "ACK" || logger -e "Erreur de transmission de ACK !" >&2
echo "ACK envoyé"
        break
fi
done


logger -e "******************** Connexion établie avec le client: $CLIENT *******************************"
sleep 2

#envoi de la clé publique du serveur

# Envoi de la clé publique du serveur par ligne
# while IFS= read -r line garantit que les espaces de début et de fin des lignes ne sont pas tronqués

logger -e "********************** envoi de la clé publique du serveur au client: $CLIENT *********************************"
while IFS= read -r line; do
    send $CLIENT "$line" || { logger -e "Erreur de transmission dans l'envoi de la clé publique du serveur au client: $CLIENT!" >&2; break; }
	sleep 1
done < <(head -n -1 "$keyPub" | tail -n +2)

#Fin
send $CLIENT "FIN" || echo "Erreur de transmission de (FIN) !" >&2

logger -e "************************* la clé publique du serveur a été envoyé au client: $CLIENT *****************************************"

#récupération de la clé publique du client

logger -e "************************** récupération de la clé publique du client: $CLIENT ************************************"

res=""
FIN="FIN"

echo "-----BEGIN PUBLIC KEY-----" > $keyClient

while true; do
    res=$(recv "$SERVEUR" || { logger -e "Erreur de réception de la clé publique du client: $CLIENT !" >&2; break; })

    # Élimination des en-têtes PEM
    key_pub=$(echo "$res" | sed -n '/-----BEGIN/,$p')

    if [[ $res =~ $FIN ]]; then
        break
    fi

    echo "$res" >> $keyClient
done

echo "-----END PUBLIC KEY-----" >> $keyClient

logger -e "******************** La clé publique du client ($CLIENT) a été bien reçue *********************************"


#Génération du sécret avec la clé publique du client et la clé privé du serveur

logger -e "************************** Génération du sécret avec la clé publique du client et la clé privé du serveur ***************************"

openssl pkeyutl -derive -inkey connexion/DH/prive/private_key.pem -peerkey connexion/DH/keyClient/public_key.pem -out connexion/DH/secret/shared_key.bin

logger -e "***************** Le secret a été généré avec succès ! **************************"

#Génération du mot de passe wifi

hexdump -e '32/1 "%02x"' connexion/DH/secret/shared_key.bin | cut -c 1-25 > configHostapd/mdp/mdp.txt

logger -e "******************* le mot de passe du wifi en hexadécimal composé de 25 caractères a été généré avec succès *****************"

sleep 2

## Envoie de la clé publique de l'utilisateur rasp
logger -e "***********************  Envoi de la clé publique de l'utilisateur rasp au client: $CLIENT ***********************************"
# Vérifiez si l'utilisateur spécifié existe
utilisateur="rasp"

if id "$utilisateur" &>/dev/null; then
    # Chemin vers le fichier de clé publique de l'utilisateur
    chemin_cle_publique="/home/$utilisateur/.ssh/id_rsa.pub"

    # Vérifiez si le fichier de clé publique existe
    if [ -e "$chemin_cle_publique" ]; then
        # Affiche la clé publique
       # sudo cat "$chemin_cle_publique"

entete=$(awk '{print $1}' "$chemin_cle_publique")
send $CLIENT "$entete" || echo "Erreur de transmission de l'entête !" >&2

	    while IFS= read -r line; do
   		 send $CLIENT "$line" || { echo "Erreur de transmission de la clé pub de l'utilisateur rasp!" >&2; break; }
		#echo "line == $line"
                 sleep 3
	    done < <(awk '{print $2}' "$chemin_cle_publique")

pied=$(awk '{print $3}' "$chemin_cle_publique")
send $CLIENT "$pied" || echo "Erreur de transmission du pied de la clé pub de l'utilisateur rasp!" >&2

		#Fin
		send $CLIENT "FIN" || echo "Erreur de transmission de (FIN)!" >&2

		logger -e "****************** la clé publique de l'utilisateur rasp a été envoyé au client ($CLIENT) ****************************"


    else
        logger -e "************************ Le fichier de clé publique n'existe pas pour l'utilisateur $utilisateur. ****************************"
    fi
else
    logger -e "**************************** L'utilisateur $utilisateur n'existe pas. ******************************"
fi
sleep 2
#Fin
send $CLIENT "FIN" || echo "Erreur de transmission de (FIN)!" >&2


logger -e "************************* la clé publique de l'utilsateur rasp a été envoyé au client avec succès ! ***********************************"


# reconfiguration  du dnsmasq

logger -e "**************** Lancement du service de reconfiguration du dnsmasq *******************"

reconfDNS="$script_dir/configDnsmasq.sh"

source "$reconfDNS"


logger -e "******************** Lancement du service de reconfiguration wifi *********************** "

#source /home/odiouma/handcheck/lib/handcheck/configHostapd/reconfigHOSTPAD.sh


# Chemin absolu vers le script reconfigHOSTPAD.sh
reconfig_script="$script_dir/configHostapd/reconfigHOSTPAD.sh"

source "$reconfig_script"


logger -e "####################### HandCkeck Serveur terminé ###########################"
