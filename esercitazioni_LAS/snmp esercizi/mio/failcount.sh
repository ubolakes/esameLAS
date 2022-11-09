#!/bin/bash

#IP passato come parametro $1

RESULT=$(snmpget -v 1 -c public "$1" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"failcount\")
echo "$RESULT"
