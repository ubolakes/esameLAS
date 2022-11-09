#!/bin/bash
# script recupera via SNMP il valore dato dall'esito di failcount
# l'IP viene passato come parametro ($1)
#per ipotesi mi fido dell'utente
IP="$1"
#richiesta snmp
ESITO=$(snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"failcount\")
#comunico in output
echo "$ESITO"
