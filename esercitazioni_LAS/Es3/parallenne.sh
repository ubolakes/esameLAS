#!/bin/bash

#prendo il numero di parametri passati
NUMCOMANDI="$#"

#creo una variabile per contare i processi terminati
TERMINATI=0

#creo un file log
> log.txt ;

# prendo tutti i comandi in input
# ciclo while
for comando in "$@"
do
    "$comando" & ; PID[$!]="$comando" ; #eseguo il comando in bg e metto il pid in un array
done

# ogni 5 secondi controllo se eseguono ancora
while sleep 5 ; do
    for pid in "${PID[@]}" ; do
        if ps "$pid" >> log.txt #metto in append a log.txt
            then
                echo "Processo $pid attivo"
            else 
                echo "Processo $pid terminato" ;
                    { PID[@]/"$pid" } ; #elimino l'elemento dall'array
                    TERMINATI=$(($TERMINATI+1)) ;                   
        fi
    done
    #guardo se il numero di terminati coincide con il numero di comandi passati
    if ! [[ "$NUMCOMANDI" -ne "$TERMINATI" ]] 
        then
            echo "Tutti i comandi passati sono stati eseguiti e terminati, termino" ; exit 1 ;
done

# se il processo viene terminato mi assicuro di terminare tutti i processi
