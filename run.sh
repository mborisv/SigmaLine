#!/bin/sh
I=1
while [ $I -gt 0 ]; do
   if [ $I -eq 1 ]
   then
      cp ./logs/syslog.log ./logs/syslog.log.OLD
      echo > ./logs/syslog.log
   fi
	echo `date` >> ./logs/syslog.log
	node ./main.js >> ./logs/syslog.log
	sleep 10
	let I+=1
done