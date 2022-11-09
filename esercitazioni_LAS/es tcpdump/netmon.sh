#!/bin/bash
#monitora il traffico tra server e client di ssh
#logga l'inizio e la fine di ogni connessione
#con tcpdump intercetto il traffico tra client e server 
# ssh usa tcp su porta 22
                                    #indirizzo sorgente     #indirizzo destinazione         #filtro per leggere la terminazione di una connessione TCP
tcpdump -i eth1 -nl tcp and src net 10.1.1.0/24 and dst net 10.2.2.0/24 and dst port 22 and '( tcp[tcpflags] & (tcp-syn|tcp-fin) !=0 )' | while read TS IP SRC DIR DST FL FLAG RESTO ; do                                                              
	SIP=$(cut -f1-4 -d. <<< $SRC) # metto i valori letti in variabili
	DIP=$(cut -f1-4 -d. <<< $DST) 
	SPT=$(cut -f5 -d. <<< $SRC)
	DPT=$(cut -f5 -d. <<< $DST | cut -f1 -d:)
	FLA=$(sed -e 's/[^SF]//g' <<< $FLAG)
	#scrivo sul logger
	logger -p local1.info <<< "_${FLA}_${SIP}_${DIP}_${SPT}_${DPT}_" 
done
