#!/bin/bash

while sleep 10 ; do
    MEM=$(free | grep ^Mem | awk '{ print $4 }')
    UPC=$(ps -hax --sort=-vsz -o uname,pid,cmd | head -1)
    logger -p local1.info "$MEM $UPC"
done
