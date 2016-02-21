# SigmaLine
control sigma ASC 105 by COM port with node js

Программа получает команды по http/https и позволяет отправить строку в таюло - бегущая строка
Отправляет статическую строку без анимации и прокрутки (если строка длиннее табло, то прокрутка срабатывает)

Установка (Linux):
sudo apt-get install git

cd path/to/your/dir

git clone https://github.com/mborisv/SigmaLine.git ./

make install

make build - копирует конфиг по умолчанию

make node -заупускается вместе с make install но так же отдельно можно для установки всех необходимых пакетов node js


Редактируем config.ini
Настраиываем ком порт

port=/dev/ttyS3

Блок sigma,

- window статическое начало строки
- color цвет статической строки
- numberColor цвет динамической строки отправляемой командой next


Доступные цвета:

- dark-red
- red
- light-yellow
- dark-orange
- light-orange
- green
- light-green
- rainbow
- red-orange
- green-red
- orange-red
- yellow-green


Блок server:

- host хост или ip адрес
- port порт
- https использование https
- httpsKey= ключ pem
- httpsCert= ключь cert

для самоподписного ключа

openssl req -newkey rsa:2048 -new -nodes -keyout key.pem -out csr.pem

openssl x509 -req -days 365 -in csr.pem -signkey key.pem -out server.crt

Key - key.pem

Cert - server.crt


Блок log:

- path путь к локам
- size размер в байтах
- rotate количество файлов по указанному размеру

Блок admin:

key ключь - пароль без кавычек для доступа к демо страничке и для установки параметров по http


Запуск сервера

make start

Остановка сервера

make stop


Описание http запросов:

http://localhost:8080/?key=123  - Демо страница, ключ должен быть в конфиге

Можно отправить следующий номер

Можно отправить строку

Можно проставить параметры конфига (которые можно изменить через сервер)

Для применени хоста и порта необходимо перезапустить сервер


http://localhost:8080/line/?message=text - отправляет сообщение text в sigma

http://localhost:8080/next/?message=text - отправляет следующее число ищменяемой области в sigma

(т.е. начало строки из конфига window затем дополняется пробелами и text в конце строки)

http://localhost:8080/set/?configKey=configValue&configKey1=configValue1

где configKey один из

- sigmaColor цвет начала строки
- sigmaNumberColor цвет конца строки -номера
- sigmaWindow текст статический начала строки
- comPort ком порт
- serverHost хост
- serverPort сетевой порт
