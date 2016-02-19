
install:
	sudo apt-get install nodejs npm build-essential nodejs-legacy
	npm install log-rotate ini serialport coffee-script

build:
	cp ./lib/default.ini ./config.ini

start:
	./run.sh &

stop:
	- kill -- `cat ./logs/run.pid`
	killall node ./node_modules/coffee-script/bin/coffee ./lib/main.coffee

