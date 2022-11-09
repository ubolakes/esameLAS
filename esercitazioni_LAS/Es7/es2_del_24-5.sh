#!/bin/bash

#realizzare uno script che resti in ascolto del traffico di rete
#con tcpdump e memorizzi il totale dei byte ricevuti da ogni IP sorgente

#dichiaro un array uno per il conteggio dei byte scambiati
declare -A TRAFFICO #conta lunghezza totale

tcpdump -i any -nl | while read TIME INT DIR PROTO SRC ARROW SRC DST RESTO ; do
    SIZE=$(echo $RESTO | awk -F 'length: ' '{ print $2 }' | cut -f1 -d' ')
    SIP=$(echo $SRC | cut -f1-4 -d:)    
    TRAFFICO[$SIP]=$(( ${TRAFFICO[$SIP]} + $SIZE ))
done
