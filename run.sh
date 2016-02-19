#!/bin/sh
#Скрипт запуска - бесконечный цикл, рассчитан на вылет программы, перезапуск с сохранением стандартного вывода
#Первый проход цикла помещает вывод в ./logs/syslog.log, при повторном переносит предыдущий лог в OLD
#Перезапуск через 10 секунд
#Сохраним pid текущего процесса
echo $$ > ./logs/run.pid
I=1
while [ $I -gt 0 ]; do
	if [ $I -eq 1 ]
	then
		#Делаем OLD лог и очищаем текущий
		cp ./logs/syslog.log ./logs/syslog.log.OLD
		echo > ./logs/syslog.log
	fi
	#выводим дату в лог
	echo `date` >> ./logs/syslog.log
	#запускаем сервер
	node ./node_modules/coffee-script/bin/coffee ./lib/main.coffee >> ./logs/syslog.log
	#10 секундная пауза
	sleep 10
	let I=2
done