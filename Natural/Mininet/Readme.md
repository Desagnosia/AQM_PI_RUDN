## Моделирование в Mininet
В данной директории находится файл сети для Mininet, а точнее для Miniedit, в нем построена определенная сеть.
Для начала работы требуется выполнить Makefile mininet, затем можно приступать к работе.
Для запуска Miniedit вводим команду:
```
sudo ./miniedit.py &
```
Открывается окно Miniedit, в левом верхнем углу на панели нажимаем на вкладку File, затем Open и выбираем файл в папке Natural/Mininet  mininir.mn, откроется топология сети.
Далее нажимаем слева внизу Run, теперь сеть запущена, добавим настройки сети, чтобы передача работала по интересующим нас параметрам (задержка сети 40 мс на s1, тип соединения на s2 - PI):
```
sudo tc qdisc add dev s1-eth1 root netem delay 40ms
sudo tc qdisc add dev s1-eth2 root netem delay 40ms
sudo tc qdisc add dev s2-eth2 root handle 1: tbf rate 100mbit burst 500000 limit 25000000
sudo tc qdisc add dev s2-eth2 parent 1: handle 2: pie limit 15000 target 45ms tupdate 10ms alpha 5 beta 30
```
После в Miniedit правой кнопкой мыши нажимаем на h1 и выбираем terminal, откроется терминал h1 в новом окне, повторить также для h2, h3.
После открытия всех терминалов в терминале h3 ввести:
```
iperf3 -s
```
В терминале h1 ввести, но не запускать: 
```
iperf3 -c 10.0.0.3 -t 30 -J > ./Natural/Mininet/out.json
```
В терминале h2 ввести, запустить и сразу после этого запустить введенную в h1 команду:
```
ping 10.0.0.3 -c 30
```
После данных команд будет работать сеть в течении 30 секунд и будет видно на терминалах информация о происходящем.
После завершения команд, можно проанализировать результат и используя скрипт plot.sh нарисовать графики.
Команды для отрисовки графиков:
```
chmod +x ./Natural/Mininet/plot.sh ./Natural/Mininet/prejson.sh
sh ./Natural/Mininet/prejson.sh ./Natural/Mininet/out.json ./Natural/Mininet/
./Natural/Mininet/plots
```
После выполнения команд в папке Natural/Mininet будет создан .pdf файл с графиками. 
Рекомендуется переименовать, чтобы не потерять предыдущий результат
Далее изменим ограничение скорости на 1 Гбит, чтобы проверить влияет ли состояние сети на PI контроллер, завершить работу Miniedit нажав Stop слева внизу, закрыть его, а затем начать с самого начала инструкции изменив 3 из набора 4 команду на приведенную ниже:
```
sudo tc qdisc add dev s2-eth2 root handle 1: tbf rate 1gbit burst 500000 limit 25000000
```