#!/bin/bash

empreinte_file="/srv/security/empreinte/resultEmptreinte.txt"

while(true)
        do 

                iphost=$(hostname -I |cut -d " " -f2)
                ipGetwaye=$(route -n |grep "^0.0.0.0"|awk '{print $2}' |head -n 1)
                empreinte=$(uname -a |sha256sum)
                echo $iphost:$empreinte > $empreinte_file
                #scp resultEmptreinte.txt rasp@$ipGetwaye:/srv/empreinte
                sleep 5
        done




