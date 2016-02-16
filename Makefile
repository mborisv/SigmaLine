
install:
	sudo apt-get install nodejs npm build-essential nodejs-legacy
	npm install log-rotate ini serialport

start:
	./run.sh

stop:
	killall node ./main.js