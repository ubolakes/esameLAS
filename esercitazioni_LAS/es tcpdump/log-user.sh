#!/bin/bash
#Si connette via SNMP alla sorgente del traffico eccessivo
#individua l'utente responsabile (indicare in snmpd.conf come sono configurati gli agent per consentire tale controllo)
#lo logga in /var/log/excess

# in snmpd.conf programmo le estensioni
# extend-sh    netmon  /bin/sudo /bin/ss -ntp
# extend-sh    users   /bin/ps -axho pid,user

#formato:
# log-user $SIP $DIP $SPT $DPT
#mi connetto con una snmpget e invoco netmon e faccio la grep per prendere la riga che mi interessa, sulla base dei parametri passati
PROCNUM=$(snmpget -v 1 -c public $1 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"netmon\" | egrep "[^0-9]+$1:$3[^0-9]+$2:$4[^0-9]+" | awk -F 'pid=' '{ print $2 }' | cut -f1 -d,)
#faccio una seconda snmpget che prende l'utente a cui e' associato il PROCNUM e lo stampo sul log
snmpget -v 1 -c public $1 NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"users\" | egrep -w $PROCNUM | awk '{ print $2 }'  | logger -p local2.info
