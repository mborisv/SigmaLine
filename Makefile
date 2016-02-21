
install:
	sudo apt-get install nodejs npm build-essential nodejs-legacy
	make node

node:
	npm install log-rotate ini serialport coffee-script process

update:
	git reset --hard
	git pull

build:
	cp ./lib/default.ini ./config.ini

start:
	./run.sh &

stop:
	echo "stopping by make stop" >> ./logs/syslog.log
	- kill -- `cat ./logs/run.pid`
	- killall node ./node_modules/coffee-script/bin/coffee ./lib/main.coffee
	echo > ./logs/run.pid
