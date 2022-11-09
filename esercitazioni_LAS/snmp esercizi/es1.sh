#!bin/bash
#Realizzare uno script che legga un elenco di IP da un file
#e restituisca su stdout l'ip della macchina che ha meno processi in esecuzione
#forma:
# nomecomando nomefile

# controllo che il file passato esista e sia un file
test -f "$1" || {
    echo "Usage: script.sh <file-name>" ; exit 1;
}
# definsico due variabili che indicano il numero di processi attivi e l'IP
JOBS=1000000000
IP=0
# OID per conoscere il numero di processi 1.3.6.1.4.1.2021.2.1.5
# leggo riga per riga gli IP
cat "$1" | while read LINE ; do
    # faccio una snmpget per sapere il numero di processi attivi
    OUTPUT=$(snmpget -v 1 -c public $LINE NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"numproc\" | awk -F 'STRING': '{ print $2 }'
    #confronto con il valore minimo dei job
    if [[ $OUTPUT -lt $JOBS ]] ; then
        JOBS=$OUTPUT
        IP=$LINE
    fi
done      
#mostro l'output
echo $IP
