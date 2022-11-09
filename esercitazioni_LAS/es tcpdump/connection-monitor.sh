#!/bin/bash
# al verificarsi della chiusura della connessione
# lo script avvia/ferma il monitoraggio della specifica connessione

# Jun  1 14:33:41 router las: _S_10.1.1.11_10.2.2.2_34804_22_

declare -A TM #definisco un array

# leggo dal log            #splitto secondo _
tail -f /var/log/newconn | while IFS=_ read PRE FLA SIP DIP SPT DPT POST  ; do
    #se viene letto l'inizio di una connessione	
    if [ "$FLA" = "S" ] ; then #invoco lo script per il monitoraggio
		/root/traffic_monitor.sh $SIP $DIP $SPT $DPT &
		TM[${SIP}_${DIP}_${SPT}_${DPT}]=$! #metto nell'array il valore di uscita
    #se viene letta la fine di una connessione
	elif [ "$FLA" = "F" ] ; then
		kill ${TM[${SIP}_${DIP}_${SPT}_${DPT}]} #termino il processo
	fi
done
