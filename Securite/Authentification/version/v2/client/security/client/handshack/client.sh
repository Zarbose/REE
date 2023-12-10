#!/bin/bash -u

logger -e "############################# HandCkeck Client ###########################"

source utils.sh


#création des répertoires

  mkdir -p connexion/DH/DHparam
  mkdir -p connexion/DH/prive
  mkdir -p connexion/DH/publique
  mkdir -p connexion/DH/secret
  mkdir -p connexion/DH/keyServeur
  mkdir -p configWPA/mdp
  mkdir -p userrasp/keyPubRasp 

# Obtenir le chemin absolu du répertoire du script principal

script_dir=$(dirname "$(readlink -f "$0")")

#configuration de l'adresse ip du client et du serveur
configScript="$script_dir/configClient.sh"

source  "$configScript"


#chemin des fichiers

keyPub="connexion/DH/publique/public_key.pem"
keyServeur="connexion/DH/keyServeur/public_key.pem"
keyPrive="connexion/DH/prive/private_key.pem"
secret="connexion/DH/secret/shared_key.bin"
dhparam="connexion/DH/DHparam/dhparam.pem"
mdp="configWPA/mdp/mdp.txt"
keyPubRasp="$script_dir/userrasp/keyPubRasp/key.pub" 
keyPubRaspTraiter="$script_dir/userrasp/keyPubRasp/keyTraiter.pub"
authorized_keys_user_rasp="/home/rasp/.ssh/authorized_keys"

#génération de la clé privé

openssl genpkey -paramfile $dhparam -out $keyPrive

logger -e "********************************   la clé privé du client a été généré avec succès ! **************************"

#génération de la clé puplique

openssl pkey -in $keyPrive -pubout -out $keyPub

logger -e "*********************** la clé publique du client a été extrait de la clé privé avec succès ! **********************"


# initier la connexion
result=""

logger -e "********************** établissement de la connexion avec le serveur: $SERVEUR *****************" 

while [ "$result" != "ACK" ]; do

    logger -e "client attend un message" >&2
    result=$(recv $CLIENT || logger -e "Erreur de reception !" >&2)

    logger -e "le client a reçu le SYN = $result " >&2

    msg="AckSyn"
    send $SERVEUR "$msg" || logger -e "Erreur de transmission (AckSyn)!" >&2

    logger -e "le client a envoyé le AckSyn et attend un message" >&2

    result=$(recv $CLIENT || echo "Erreur de reception !" >&2)

    logger -e "result = $result"

    if [ "$result" == "ACK" ]; then
        break
    fi
done

logger -e "************* Connexion établie avec le serveur: $SERVEUR ******************"

sleep 2

#recevoire la clé publique du serveur

logger -e "******************* récupération de la clé publique du serveur: $SERVEUR ****************"

res=""
FIN="FIN"
echo "-----BEGIN PUBLIC KEY-----" > $keyServeur 

while true; do
    res=$(recv "$CLIENT" || { logger -e "Erreur de réception de la clé publique du serveur: $SERVEUR !" >&2; break; })

    # Élimination des en-têtes PEM
    key_pub=$(echo "$res" | sed -n '/-----BEGIN/,$p')

    if [[ $res =~ $FIN ]]; then
        break
    fi

    echo "$res" >> $keyServeur 
done

echo "-----END PUBLIC KEY-----" >> $keyServeur

logger -e "********************* La clé publique du serveur ($SERVEUR) a été bien reçue **************************"


# Envoi de la clé publique du client par ligne au serveur

logger -e "************************ envoi de la clé publique du client au serveur: $SERVEUR ****************************"

# while IFS= read -r line garantit que les espaces de début et de fin des lignes ne sont pas tronqués
while IFS= read -r line; do
    send $SERVEUR "$line" || { logger -e "Erreur de transmission  de la clé publique du client au serveur: $SERVEUR !" >&2; break; }
        sleep 1
done < <(head -n -1 "$keyPub" | tail -n +2)

#Fin

send $SERVEUR "FIN" || logger -e "Erreur de transmission (!" >&2

logger -e "*********************** la clé publique du serveur a été envoyé au client ****************"


#Génération du sécret avec la clé publique du serveur et la clé privé du client

logger -e "******************** Génération du sécret avec la clé publique du serveur et la clé privé du client ******************-"

openssl pkeyutl -derive -inkey $keyPrive -peerkey $keyServeur -out $secret


#echo "Le secret a été généré avec succès !"
logger -e "***************** Le secret a été généré avec succès ! ***************"

#Génération du mot de passe wifi

hexdump -e '32/1 "%02x"' $secret | cut -c 1-25 > $mdp

logger -e "************* le mot de passe du wifi en hexadécimal composé de 25 caractères a été généré avec succès ******************"

# reception de la clé publique de l'utilsateur rasp

echo -n "" > $keyPubRasp

logger -e "********************** recception de la clé publique de l'utilsateur rasp du serveur: $SERVEUR **************************"

while true; do
    res=$(recv "$CLIENT" || { echo "***************** Erreur de réception  de la clé publique de l'utilsateur rasp du serveur: $SERVEUR ! *****************" >&2; break; })

    # Élimination des en-têtes PEM
    key_pub=$(echo "$res" | sed -n '/-----BEGIN/,$p')

    if [[ $res =~ $FIN ]]; then
        break
    fi

    echo "$res" >> $keyPubRasp
done

logger -e "*************** la clé publique de l'utilsateur rasp a été bien reçue ********************"

#suppression des retours en lignes
cat $keyPubRasp | tr '\n' ' ' > $keyPubRaspTraiter && echo >> $keyPubRaspTraiter


#enregistrement de la clé pub ssh chez l'utilisateur rasp

echo "" |sudo tee $authorized_keys_user_rasp

logger -e "Le fichier authorized_keya été vidé !"

cat $keyPubRaspTraiter |sudo tee $authorized_keys_user_rasp

logger -e "******************** La clé publique ssh rsa de l'utilisateur rasp a été enregistrer avec succès ! **********************"

# Chemin absolu vers le script reconfigHOSTPAD.sh
reconfig_script="$script_dir/configWPA/reconfigWPA.sh"

logger -e "******************* Lancement du service de reconfiguration de wpa *************************** "

source "$reconfig_script"



logger -e "########################### HandCkeck client terminé ##############################"

