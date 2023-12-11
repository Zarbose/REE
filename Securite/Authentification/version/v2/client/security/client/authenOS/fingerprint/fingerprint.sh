#!/bin/bash

while(true)
	do 
		
		iphost=$(hostname -I |cut -d " " -f2)
		ipGetwaye=$(route -n |grep "^0.0.0.0"|awk '{print $2}' |head -n 1)
		empreinte=$(uname -a |sha256sum)
		echo $iphost:$empreinte > /srv/empreinte/resultEmptreinte.txt
		#scp resultEmptreinte.txt rasp@$ipGetwaye:/srv/empreinte
		sleep 5
	done
