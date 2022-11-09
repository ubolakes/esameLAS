#!/bin/bash
#forma:
#comando directory est1 est2 ... estn

#controllo che il primo arg sia una dir
test -d $1 || { echo "inserire il nome di una directory"; exit 1 ; }
#controllo che ci sia almeno un parametro
test $2 || { echo "inserire almeno un parametro"; exit 2 ; }

#associo la var DIR al primo parametro
DIR="$1"
shift
REG="\.($1" #ho shiftato e quindi $1 e' la prima estensione passata
shift
for ESTENSIONE in "$@" #ciclo for su tutti i parametri in input allo script
do
    REG="$REG|$ESTENSIONE" #tramite pipe concateno la regex e l'espressione
done
REG="$REG)$" #chiudo la regex

find "$DIR" -type f | egrep "$REG" | rev | cut -f1 -d. | rev | sort | uniq -c
#cerco file di tipo file
#prendo quello che contengono $REG
#inverto i nomi
#taglio il nome in prossimita' del .
#inverto di nuovo i nomi
#li ordino
#elimino i doppi e li conto
