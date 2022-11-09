#!/bin/bash
function writer() {
    while sleep 1; do
        dd if=/dev/zero bs=1k count=$(( $(echo $RANDOM | rev | cut -c1) + 1 ))
    done >> output
}

function redo() {
writer & PID=$!
ORIGINO=$(stat --format=%i output)
}

redo

while sleep 1 ; do
    if [[ ! -f output ]] ; then
        redo
    elif [[ $(stat --format=%i output) != $ORIGINO ]] ; then
        redo
    elif [[ $(ls -i | egrep -w "^$ORIGINO " | grep -v " output$" ) ]] ; then
        redo
    fi
done
