#!/bin/bash
report () {
	echo $(date) osservate $TOT nuove righe
	TOT=0
}
echo $BASHPID > /tmp/logwatch.pid #scrive il pid della shell nel file di log
TOT=0
trap report USR1 #trap intercetta il segnale USR1 e invoca l'handler report
# tail da in output tutte le linee e il file descriptor del file passato come argomento
# read prende in input l'output di tail e ne conta le linee
# per ogni ciclo viene incrementato di 1 il valore della variabile TOT
tail -n +0 -f "$1" | while read R ; do
	TOT=$(( $TOT + 1 ))
done

# Lo script conta le righe del file passato e ogni volta inserisce il fd a fine file
# alla ricezione di un segnale comunica all'utente il numero di righe lette e resetta il counter

# Per far funzionare correttamente deve esserci un ciclo
# perche' il processo termina dopo l'incremento di TOT

# Ipotesi di script corretto:

#!/bin/bash
report () {
	echo $(date) osservate $TOT nuove righe
	TOT=0
}

while true ; do
    if [[ -f "$1" ]] ; then #controllo che il file passato sia tale ed esista   
        TOT=0        
        echo $BASHPID > /tmp/logwatch.pid # scrivo ad ogni iterazione sul log        
        trap report USR1 
        tail -n +0 -f "$1" | while read R ; do
	        TOT=$(( $TOT + 1 ))
        done
    else # se non ho un argomento attendo 5s in attesa che l'utente lo inserisca
        sleep 5
    fi
done
