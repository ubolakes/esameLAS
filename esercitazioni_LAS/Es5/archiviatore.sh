#!/bin/bash

# formato: comando directory

# controllo che la directory passata sia tale, altrimenti exit
DIR="$1"
if ! [[ test -d "$DIR" ]]
    then echo "La directory passata non e' valida" || exit -1 ;

# uso una variabile temp per salvare i nomi dei file che rispettano le condizioni e che dovro' archiviare
# faccio una ricerca ricorsiva dei file nella directory e sotto directory
# per ogni file controllo se e' verificata almeno una delle seguenti condizioni
# - il file e' stato modificato o acceduto nell'ultima settimana
find "$1" -mtime -7 > temp
# - il file ha SUID o SGID settato e non e' di root
find "$1" -perm /4000 | find "$1" -not -user root >> temp 
find "$1" -perm /2000 | find "$1" -not -user root >> temp
# - il file e' di tipo text, ha dim < 100K e contiene la stringa "DOC"
find "$1" -type f -size -100K | grep "ASCII text" | grep -l "DOC" >> temp

# i file che hanno verificato almeno uno di questi vengono archiviati in backup_DATA.tar.gz
# con DATA in formato AAAAMMGG_HHMM
DATA=$(date +%Y%m%e_%H%M) # per produrre la data nella forma richiesta
#comando per archiviare
tar lista -czf backup_$DATA.tar.gz

