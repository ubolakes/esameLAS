#!/bin/bash

#forma: niceexec.sh -n MAX_TENTATIVI -s SOGLIA_CARICO  COMANDO_DA_ESEGUIRE  PARAMETRI
#se il carico di sistema < soglia lancio comando
#altrimenti con at schedula il test 2 minuti dopo
#fa cosi' fino a che non e'possibile lanciare il comando

usage() { echo "Usage: $0 [-n MAX_TENTATIVI -s SOGLIA_CARICO COMANDO_DA_ESEGUIRE  PARAMETRI]" 1>&2; exit 1; }

#switch con le opzioni
while getopts ":n:s:" o; do
    case "${o}" in
        s)
            n=${OPTARG}
            [[ n =~ ^[0-9]+$ ]] || usage
            ;;
        p)
            s=${OPTARG}
            [[ s -gt 100 ]] || usage
            ;;
        *)
            usage
            ;;
    esac
done

#con uptime ottengo il valore, devo fare cut e varie
CARICO=$(uptime | cut -f5 -d: | cut -f1 -d, | cut -f1 -d.)
LANCIATO=0 #mi dice se il comando e' stato lanciato

#controllo che CARICO sia valido
if [[ "$CARICO" -gt "100" ]]
    then echo "Valore di carico non valido" | exit 1 ;
fi

# ad ogni tentativo senza successo decremento il valore di 1

if [[ "$CARICO" -lt "$4" && "$LANCIATO" -ne 1 && "$2" -gt 0 ]]
    then
        LANCIATO=1 ;
        $3 $4 #eseguo il comando con parametri
elif [[ "$3" -gt 0 ]] ; then
    (("$3"--)) ; #decremento il numero di tentativi di 1
    echo "$0 $1 $2 $3 $4 $5 $6" | at now + 2 minutes; #chiamata ricorsiva tra due minuti che reinvoca lo script
fi




