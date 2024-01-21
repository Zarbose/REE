#!/bin/bash -u

logger -e "########################## Service default configuration serveur ########################"

# Obtenir le chemin absolu du répertoire du script principal
script_dir=$(dirname "$(readlink -f "$0")")

val=0

while true; do
    sleep 1m  # 5 minutes

    clt_connecter=$(iw dev wlan0 station dump)

    if [ -n "$clt_connecter" ]; then
        val=0
    else
        val=$((val+5))

        if [ "$val" -ge 15 ]; then
            source "$script_dir/defaultConfigServer.sh"
            val=0
        fi
    fi
done

