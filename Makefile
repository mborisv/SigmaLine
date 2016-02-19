
install:
	sudo apt-get install nodejs npm build-essential nodejs-legacy
	npm install log-rotate ini serialport

build:
	cp ./default.ini ./ config.ini

start:
	./run.sh &

stop:
	killall ./run.sh
	killall node ./main.js
