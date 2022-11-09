#!/bin/bash

# a) Interroga via SNMP il Router, che deve rispondere col contenuto del proprio file /tmp/server.attivo. Il contenuto di tale file consiste nel nome di un
# server (Server1 o Server2) seguito eventualmente da uno spazio e dalla parola "new"

# b) Se il risultato ottenuto contiene il nome del server su cui è in esecuzione lo script (Server1 o Server2), lo script assegna all'interfaccia eth2 l'indirizzo
# aggiuntivo 10.20.20.20, altrimenti lo script si assicura che l'interfaccia eth2 non detenga l'indirizzo 10.20.20.20, deconfigurandolo se necessario.

# c) Lancia lo script ldap.sh, passando come parametro la parola "new" se è presente nella risposta SNMP

# Configurare Server1 per eseguire failback.sh a ogni minuto dispari, e Server2 per eseguirlo a ogni minuto pari. -> viene fatto con ansible

snmpget -v 1 -c public 10.20.20.254 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"failback\" |
awk -F 'STRING: ' '{ print $2 }' | ( #
    read NAME PARAM # leggo la riga
    if [[ "$NAME" == "$HOSTNAME" ]] ; then
        ip a | grep -qw 10.20.20.20/24 || ip a add 10.20.20.20/24 dev eth2 # se non trovo, aggiungo
    else
        ip a | grep -qw 10.20.20.20/24 && ip a del 10.20.20.20/24 dev eth2 # se trovo, elimino
    fi
    
    ldap.sh "$PARAM"
)

