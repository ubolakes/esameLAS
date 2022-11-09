#!/bin/bash

#Se logrotate.sh  si rileva lanciato da terminale (man tty)
#configura rsyslog per dirigere i messaggi etichettati local1 con priorità non inferiore a warning sul file /var/log/my.log
#configura la cron table di root per esegure se stesso ogni giorno lavorativo alle 23:00
#In caso contrario, effettua la "rotazione" del file /var/log/my.log 
#rinomina eventuali file /var/log/my.log.N.bz2 in /var/log/my.log.N+1.bz2 (per ogni N esistente)
#rinomina /var/log/my.log in /var/log/my.log.1 e lo comprime con bzip2
#ricarica rsyslogd (più in generale il processo che vi sta scrivendo man fuser

PATH=/home/las/logrotate.sh

NUMCOPIE=4
LOGSIGNAL=USR1

while getopts "n:s:" OPTION ; do
	case $OPTION in
		n)	NUMCOPIE="$OPTARG"
			;;
		s)	LOGSIGNAL="$OPTARG"
			;;
		?)	printf "Usage: %s [-n copie_da_mantenere] [-s segnale_da_inviare] filename\n" $(basename $0) >&2
			exit 1
			;;
	esac
done

if /usr/bin/tty > /dev/null ; then
	# se invocato da terminale
	if ! [[ $NUMCOPIE =~ ^[0-9]+$ ]] ; then
		echo "-n deve essere seguito da un valore intero"
		exit 2
	fi

	if ! /bin/kill -l | grep -w "$LOGSIGNAL" ; then #controllo che il segnale passato come argomento esista
		echo "-s deve essere seguito da un nome di segnale valido ("$(/bin/kill -l)
		exit 3
	fi

	shift $(($OPTIND - 1)) #faccio uno shift degli input
	if ! test -f "$1" ; then #controllo che il file passato sia un file
		echo "$1 non e' un file standard"
		exit 4
	fi

	LOGFILE=$1

	# configuro cron
	/usr/bin/crontab -l | grep -v "$PATH -n $NUMCOPIE -s $LOGSIGNAL $LOGFILE" > /tmp/niceexec.cron.$$
	echo "00 22 * * 1-5 $THIS -n $NCOPIES -s $LOGSIGNAL $LOGFILE" >> /tmp/niceexec.cron.$$
	/usr/bin/crontab /tmp/niceexec.cron.$$
	/bin/rm -f /tmp/niceexec.cron.$$
else
	# invocato da cron, ruota file

	# sposta $FNAME.9 in $FNAME.10 sovrascrivendolo
	# alla fine non esistera' piu' $FNAME.1

	for i in $(seq $(( $NUMCOPIE - 1 )) -1 1) ; do
		test -f $LOGFILE.$i && mv $LOGFILE.$i $LOGFILE.$(( $i + 1 ))
	done

	# rinomina il file aperto dal processo 
	# contina a scrivere sullo stesso inode col nuovo nome
	mv $LOGFILE $LOGFILE.1z

	# segnala al logger di chiudere i file aperti e riaprirli 
	# il logger ricrea il file col nome originale
	fuser -k -$LOGSIGNAL $LOGFILE.1
fi
	
