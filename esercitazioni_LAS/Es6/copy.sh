#!/bin/bash
# modificare in modo che ogni 4 ore esegua un backup
while sleep 4h ; do 
tar --files-from=save.list -cf "bck.$(date --iso-8601).tgz"
done
