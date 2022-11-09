#!/bin/bash

case "$1" in
    start)
        echo 'local1.=info /var/log/sd.log' > /etc/rsyslog.d/ramlog.conf
        /usr/bin/systemctl restart rsyslog
        ;;
    stop)
        rm /etc/rsyslog.d/ramlog.conf
        /usr/bin/systemctl restart rsyslog
        ;;
    *)
        exit 1
        ;;
esac
