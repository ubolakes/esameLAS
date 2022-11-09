#lo script interroga usando failcount.sh tutti gli host elencati in FILE. Per ogni host che riporta un valore superiore a SOGLIA, lo script si collega via ssh  all'host e lo spegne.
#sintassi: failkill.sh -f <nome-file> -s <soglia>

#prendo i parametri
while getopts "f:s:" OPTION ; do
	case $OPTION in
		f)	FILE="$OPTARG"
			;;
		s)	SOGLIA="$OPTARG"
			;;
		?)	printf "Usage: %s -f FILE -s SOGLIA\n" $(basename $0) >&2
			exit 1
			;;
	esac
done

#controllo che il file esista
[[ -f "$FILE" ]] || exit 1;

#richiesta ricorsiva con SNMP di tutti gli host in file
while read LINE; do
    #invoco lo script prodotto prima    
    ESITO=$( ./failcount.sh "$LINE")
    #controllo
    if [[ "$ESITO" -gt "$SOGLIA" ]] ; then
        #mi collego con ssh e faccio uno shutdown
        ssh "$LINE" | shutdown -P
    fi
done < "$FILE"
