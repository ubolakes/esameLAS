#!/bin/bash

sleep 10 & #avvio il processo in background
PID1=$! #ne salvo il PID in una variabile

sleep 20 &
PID2=$!

while sleep 5 ; do
  if ps "$PID1" > /dev/null
  then
    echo "Processo $PID1 attivo"
    break
  fi
  if ps "$PID2" > /dev/null
    then
        echo "Processo $PID2 attivo"
    break  
  fi
done
