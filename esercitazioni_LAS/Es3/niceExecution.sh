#!/bin/bash

#forma: niceExecution soglia comando
#se il carico di sistema < soglia lancio comando
#altrimenti con at schedula il test 2 minuti dopo
#fa cosi' fino a che non e'possibile lanciare il comando

#con uptime ottengo il valore, devo fare cut e varie
CARICO=$(uptime | cut -f5 -d: | cut -f1 -d, | cut -f1 -d.)
LANCIATO=0 #mi dice se il comando e' stato lanciato

#controllo che CARICO sia valido
if [[ "$CARICO" -gt "100" ]]
    then echo "Valore di carico non valido" | exit 1 ;
fi

if [[ $CARICO -lt $1 && "$LANCIATO" -ne 1 ]]
    then
        LANCIATO=1 ;
        $2 #eseguo il comando
else 
    echo "$0 $@" | at now + 2 minutes; #chiamata ricorsiva tra due minuti che reinvoca lo script
fi
