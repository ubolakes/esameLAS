#!/bin/bash

#forma logconfig.sh stringa fileName
#la stringa e' informato facility.priority
#configura syslog per loggare i messaggi con l'etichetta specificata sul relativo file
#cron per mandare l'output del comando uptime a syslog con l'etichetta specificata

#splitto la stringa in 2 parti
FACILITY=$( "$1" | cut -f1 -d. )
PRIORITY=$( "$1" | cut -f2 -d. )

#metto $2 in una variabile
FILENAME="$2"

#controllo che il file passato esista
if ! [[ "$FILENAME" -f ]]
    then 
        echo "File passato non valido" ; exit 1 ;
fi

#configuro syslog
#creo un nuovo file
echo "local4.=info  /var/log/myevents.log" > /etc/rsyslog.d/mylog.conf

