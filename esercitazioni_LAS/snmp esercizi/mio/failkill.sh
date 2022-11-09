#!/bin/bash

while getopts "f:s:" OPTION ; do
        case $OPTION in
            f) FILE="$OPTION"
                ;;
            s) SOGLIA="$OPTION"
                ;;
            ?) printf "Usage: ... "
               exit 1
                ;;
        esac
    done
#controllo che il file esista
[[ -f "$FILE" ]] || echo "File non valido" ; exit 1
#leggo il file linea per linea
while read LINE ; do
   VALUE=$( ./failcount.sh "$LINE" )
   if [[ "$VALUE" -gt "$SOGLIA" ]] ; then
      ssh "$LINE" | shutdown -P
   fi
done < "$FILE"

