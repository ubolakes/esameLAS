#!/bin/bash

#dichiaro un array per il conteggio
declare -A COUNT #conta pacchetti scambiati

#analizzo il contenuto di nfs.log.last e per ogni IP calcolo la lunghezza tot dei pacchetti e il num totale dei pacchetti
cat /var/log/nfs.log.last | while IFS=_ HEAD S D L TAIL
do
    [[ "$S" =~ "10.10.10." ]] && IP="$S"
    [[ "$D" =~ "10.10.10." ]] && IP="$D"
    (( LEN[$IP] += $L ))
    (( COUNT[$IP] += 1 ))
done

#faccio un ciclo sugli array
for C in ${!LEN[$@]} ; do
    [[ ${COUNT[$C]} -gt 10000 ]] && /root/alert.sh $C
done

