#!/bin/sh
#Скрипт запуска - бесконечный цикл, рассчитан на вылет программы, перезапуск с сохранением стандартного вывода
#Первый проход цикла помещает вывод в ./logs/syslog.log, при повторном переносит предыдущий лог в OLD
#Перезапуск через 10 секунд
#Сохраним pid текущего процесса
I=1
while [ $I -gt 0 ]; do
	if [ $I -eq 1 ]
	then
		if [ -f ./logs/syslog.log ]; then
			#копируем старый лог в OLD
			cp ./logs/syslog.log ./logs/syslog.log.OLD
		fi
		#Чистим сарый лог
		echo > ./logs/syslog.log
	fi
	#выводим дату в лог
	echo `date` >> ./logs/syslog.log
	#запускаем сервер
	echo $$ > ./logs/run.pid
	node ./node_modules/coffee-script/bin/coffee ./lib/main.coffee >> ./logs/syslog.log
	#10 секундная пауза
	sleep 10
	I=$((I+1))
done