#!/bin/bash

#a) Se è presente un parametro di valore "new", devono essere cancellate dalla directory locale tutte le entry sotto ou=People,dc=labammsis, e
#devono essere sostituite col contenuto del file /tmp/dir.backup del Router, prelevato via SSH/SCP

#b) Se non è presente alcun parametro, deve essere fatto un dump in formato LDIF di tutte le entry sotto ou=People,dc=labammsis, e trasferito via
#SSH/SCP nel file /tmp/dir.backup del Router

#c) Se è presente un parametro ma di valore diverso, o più parametri, devono essere loggati via syslog sul file /var/log/ldap.errors del Router

if [[ "$1" = "new" && -z "$2" ]] ; then
    #faccio la ricerca ed elimino le entry dalla directory ldap    
    ldapsearch −x −LLL −D cn=admin,dc=labammsis −b ou=People,dc=labammsis -s one −w gennaio.marzo −H ldapi:/// |
        egrep ^dn: | ldapdelete -x -D cn=admin,dc=labammsis −b dc=labammsis −w gennaio.marzo −H ldapi:///
    #prendo dal router le info con ssh e le metto nella directory ldap
    ssh 10.20.20.254 "cat /tmp/dir.backup" | ldapadd -x -D cn=admin,dc=labammsis −b dc=labammsis −w gennaio.marzo −H ldapi:///

elif [ -z "$1" ] ; then
    #prendo le entry e le metto sul router
    ldapsearch −x −LLL −D cn=admin,dc=labammsis −b ou=People,dc=labammsis -s one −w gennaio.marzo −H ldapi:/// |
    ssh 10.20.20.254 "cat > /tmp/dir.backup"
else
    # creo un record di log con i parametri passati
    logger -p local1.notice -t parametri "$@"
fi
