#!/bin/bash
#durante la "vita" di ogni connessione, tracciata con una specifica istanza di tcpdump, al superamento di una certa soglia espressa in numero di pacchetti per minuto, usare log-user.sh per individuare l'utente responsabile e loggare lo username nel file /var/log/excess;
#formato
# script $SIP $DIP $SPT $DPT
# soglia pacchetti per minuto
SOGLIA=100 #scelto di default da me
# contatore pacchetti scambiati
COUNTER=0
# momento in cui resetto il contatore
RESET= $(( $(date +%s) + 60 ))
tcpdump -i eth1 -nl tcp and src net "$1" and src port "$3" and dst net "$2" and dst port "$4" | while read PK ; do
    (( COUNTER ++ ))
    if [[ $(date +%s) -ge $RESET ]] ; then
        RESET= $(( $(date +%s) + 60 ))
        COUNTER=0
    elif [[ $COUNTER -gt $SOGLIA ]] ; then
        ./log-user.sh "$@"
        RESET= $(( $(date +%s) + 60 ))
        COUNTER=
    fi
done
