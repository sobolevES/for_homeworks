1. >На лекции мы познакомились с `node_exporter`. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по `systemd`, создайте самостоятельно простой `unit-файл` для `node_exporter`:
   поместите его в автозагрузку,
   предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
   удостоверьтесь, что с помощью `systemctl` процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

Прочитал, что можно создать юзера без домашней директории и без возможности зайти в оболочку, ну я так и сделал :)  
`sudo useradd --no-create-home --shell /bin/false node_exporter`  

Скачал дистр, разархивировал в раздел, откуда будем запускать службу и раздал права нашему юзеру на каталог.  
`curl -fsSL https://github.com/prometheus/node_exporter/releases/download/v1.1.0/node_exporter-1.1.0.linux-amd64.tar.gz \`  
`| sudo tar -zxvf -C /usr/local/bin --strip-components=1 node_exporter-1.1.0.linux-amd64/node_exporter \`  
`&& sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter`  
  
Создал простой unit-файл  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.1_OS2.JPG)  
  
Обновил конфиги демонов, стартанул службу, проверил ее статус и запихал в автозагрузку.  
`sudo systemctl daemon-reload && \`  
`sudo systemctl start node_exporter && \`  
`sudo systemctl status node_exporter && \`  
`sudo systemctl enable node_exporter`  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.2_OS2.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.3_OS2.JPG)  
  
2. >Ознакомьтесь с опциями `node_exporter` и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.  

смотрим портянку `curl -s http://localhost:9100/metrics`  

*Так будем следить за средней загрузкой CPU  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_OS2.JPG)  
  
*За свободным местом в файло.  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.2_OS2.JPG)  
  
*Будем смотреть средний входящий трафик через сетевые интерфейсы байт/сек.  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.3_OS2.JPG)  
  
*Так будем смотреть за свободной памятью.  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.4_OS2.JPG)  

3. >Установите в свою виртуальную машину `Netdata`. Воспользуйтесь готовыми пакетами для установки (`sudo apt install -y netdata`). После успешной установки:    
в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с `localhost` на `bind to = 0.0.0.0`,    
добавьте в `Vagrantfile` проброс порта `Netdata` на свой локальный компьютер и сделайте `vagrant reload`:  
`config.vm.network "forwarded_port", guest: 19999, host: 19999  `
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. 
   Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.  


Установил, настроил, по метрикам пробежался  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3_OS2.JPG)  

4. >Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?  
  
dmesg используется для проверки кольцевого буфера ядра или управления им.  
Если первый греп ничего не даст, значит система физическая.  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4_OS2.JPG)  
  
5. >Как настроен `sysctl fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

`sysctl fs.nr_open`  =  `cat /proc/sys/fs/nr_open`  
Это системное ограничение на лимит количества открытых дескрипторов:  
`vagrant@ubuntu-devops5:~$ sysctl fs.nr_open`  
`fs.nr_open = 1048576`  
  
Но, пользовательский лимит равен 1024. Этот лимит и будет решающим.  
`vagrant@ubuntu-devops5:~$ ulimit -n`  
`1024`
  
Насколько я понял он кастомный и при необходимости можно изменить параметр как на временной основе, так и на постоянку, как для системы, так и для каждого юзера.  
Первично изучить вывод  `ulimit -a` и `ulimit` -Ha` и далее уже менять параметры в конфигах `/etc/sysctl.conf`  или `/etc/security/limits.conf`  
  
6. >Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под `PID 1` через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6_OS2.JPG)  
  
7. >Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
  
`:(){ :|:& };:`   - Как пишут на просторах интернета - это Fork Bomb. Функция, которая запускает сама себя бесконечное кол-во раз, пока системе не станет плохо.  
  
:() — Объявили функцию.  
{  — Открыли функции.  
: |: — вызывает сама себя и передает результат на другой вызов функции ':'. Функция будет вызвана уже дважды.  
& — Помещает вызов функции в фоновый режим, чтобы fork (дочерний процесс) не мог «умереть» вообще.  
} — Закрыли функции.  
; — Завершили определение функции  
: — Запустили функцию которая порождает fork bomb().  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/7.1_OS2.JPG)  
  
Почитав про: `blocked for more than 120 seconds.   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message`  
становится понятно, что сообщение возникает, как только определенный процесс блочится и не может обратится к ядру более чем 120 сек.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/7.2_OS2.JPG)  
  
Как только мы дойдем до лимита на число процессов (2572) ос быстро исчерпывает физическую память и уйдет в своп.  
И тут нам на помощь приходит триггер hung_task_timeout_secs, который увидит, что процесс висяк и скинет его по тайм-ауту.  


