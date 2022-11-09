ls -R / 2>/dev/null | grep -v ':$' | rev | cut -s -d. -f1 | rev | sort | uniq -c | sort -nr | head -5
#ls ricorsiva, guarda in tutti i le sottodirectory
#stdout viene riderezionato su su /dev/null
#grep seleziona i nomi file che non matchano :$
#rev inverte i caratteri, inizia a leggere dal fondo
#cut stampa solo le linee che non contengono il delimiter '.'
#rev inverte di nuovo
#sort mette in ordine
#uniq elimina gli elementi che ho gia' e conta
#sort compara al valore numerico della stringa e inverte il risultato della comparazione
#head prende solo le prime 5 righe
