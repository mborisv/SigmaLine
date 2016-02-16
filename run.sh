#!/bin/sh
i=0
while [++i]
do
   if [i == 1]
   then
      cp ./syslog.log ./syslog.log.OLD
      echo > ./syslog.log
   fi
   node ./main.js >> syslog.log
   sleep 10
done