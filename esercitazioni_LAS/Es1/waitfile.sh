function waitfile() {
    echo "$1" | egrep -q '^(rm|ls|touch)$' || {
        echo 'comando non supportato'
        return 101
    }
    #faccio uno switch per distinguere i casi
    #uso la variabile TROVATO per determinare se ho trovato il terzo elemento
    #WAIT per gestire i cicli
    case "$3" in
        force)
            FOUND=1
            ;;
        [1-9])
            FOUND=0
            NUMCICLES=$3
            ;;
        *)
            FOUND=0
            NUMCICLES=10
            ;;
    esac
    #ciclo while
    #ogni iterazione decremento NUMCICLES, se e' >= 0 e FOUND == 0 itero
    while [[ $(( -- NUMCICLES )) -ge 0 && $FOUND -eq 0 ]] ; do
        sleep 1
        test -f "$2" && FOUND=1 #faccio il controllo per vedere se e' presente il secondo elemento e se c'e' pongo a 1 FOUND
    done
    #termine del ciclo
    if [[ $FOUND -eq 0 ]] ; then
        echo "non trovato" >&2
        return 102
    else
        "$1" "$2" #eseguo il comando
        return $? #ritorno l'exit status dell'ultimo comando eseguito
    fi
}
