#!/bin/bash -u

logger -e "########################## Service default configuration client ########################"

# Obtenir le chemin absolu du répertoire du script principal
script_dir=$(dirname "$(readlink -f "$0")")

val=0

while true; do
    sleep 1m  # 5 minutes

    clt_connected=$(iw dev wlan1 link)

    if [[ "$clt_connected" == *"Not connected"* ]]; then
        val=$((val+5))

        if [ "$val" -ge 15 ]; then
            echo "Exécution du script"
            source "$script_dir/defaultConfigClient.sh"
            val=0
        fi
    else
        val=0
    fi
done

