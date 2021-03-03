1. >`ipvs`. Если при запросе на VIP сделать подряд несколько запросов (например, `for i in {1..50}; do curl -I -s 172.28.128.200>/dev/null; done` ), ответы будут получены почти мгновенно. Тем не менее, в выводе `ipvsadm -Ln` еще некоторое время будут висеть активные `InActConn`. Почему так происходит?

Если исходить из того, что мы устанавливаем TCP-соединение, а оно имеет свой жизненный цикл, то думаю в эту сторону нужно идти.

ActiveConn - коннекты в статусе ESTABLISHED  
InActConn - все остальные

Думаю, что после того, как мы запросили и в итоге получили ответ на наш запрос от сервера, к которому обращались, он инициализирует закрытие сессии.
А на нашей стороне коннект переходит в состояние FIN-WAIT и через заданное в конфигах значение произойдет таймаут и соединение закроется, ну и
пропадет из `ipsvadm`.

немного позже нашел уже подтверждающую информацию на просторах инета.

"With LVS-NAT, the director sees all the packets between the client and the realserver, so always knows the state of tcp connections and the listing from ipvsadm is accurate. However for LVS-DR, LVS-Tun, the director does not see the packets from the realserver to the client. Termination of the tcp connection occurs by one of the ends sending a FIN (see W. Richard Stevens, TCP/IP Illustrated Vol 1, ch 18, 1994, pub Addison Wesley) followed by reply ACK from the other end. Then the other end sends its FIN, followed by an ACK from the first machine. If the realserver initiates termination of the connection, the director will only be able to infer that this has happened from seeing the ACK from the client. In either case the director has to infer that the connection has closed from partial information and uses its own table of timeouts to declare that the connection has terminated. Thus the count in the InActConn column for LVS-DR, LVS-Tun is inferred rather than real.

Entries in the ActiveConn column come from

-service with an established connection. Examples of services which hold connections in the ESTABLISHED state for long enough to see with ipvsadm are telnet and ftp (port 21).

Entries in the InActConn column come from

-Normal operation  
**Services like http (in non-persistent i.e. HTTP /1.0 mode) or ftp-data(port 20) which close the connections as soon as the hit/data (html page, or gif etc) has been retrieved (<1sec). You're unlikely to see anything in the ActiveConn column with these LVS'ed services. You'll see an entry in the InActConn column untill the connection times out. If you're getting 1000connections/sec and it takes 60secs for the connection to time out (the normal timeout), then you'll have 60,000 InActConns. This number of InActConn is quite normal. If you are running an e-commerce site with 300secs of persistence, you'll have 300,000 InActConn entries. Each entry takes 128bytes (300,000 entries is about 40M of memory, make sure you have enough RAM for your application). The number of ActiveConn might be very small.**

-Pathological Conditions (i.e. your LVS is not setup properly)  
identd delayed connections: The 3 way handshake to establish a connection takes only 3 exchanges of packets (i.e. it's quick on any normal network) and you won't be quick enough with ipvsadm to see the connection in the states before it becomes ESTABLISHED. However if the service on the realserver is under authd/identd, you'll see an InActConn entry during the delay period.
Incorrect routing (usually the wrong default gw for the realservers):
In this case the 3 way handshake will never complete, the connection will hang, and there'll be an entry in the InActConn column.
Usually the number of InActConn will be larger or very much larger than the number of ActiveConn.
"

2. >На лекции мы познакомились отдельно с ipvs и отдельно с keepalived. Воспользовавшись этими знаниями, совместите технологии вместе (VIP должен подниматься демоном keepalived). Приложите конфигурационные файлы, которые у вас получились, и продемонстрируйте работу получившейся конструкции. Используйте для директора отдельный хост, не совмещая его с риалом! Подобная схема возможна, но выходит за рамки рассмотренного на лекции.  
   Keepalived используется в качестве управляющего ПО для организации мониторинга
   и обеспечения высокой доступности узлов и сервисов.
   Демон Keepalived обеспечивает автоматический переход на резервный ресурс в
   режиме ожидания в случае возникновения ошибки или сбоя основного ресурса.
   Для обеспечения автоматического перехода используется протокол VRRP (Virtual Redundancy Routing Protocol).
   Данный протокол позволяет использовать виртуальный IPадрес VIP (virtual IP), который является плавающим (расшаренным) между узлами.

Для реализации мне потребовалось 4 VM (2 loadbalancer's, 2 server's на каждом развернут nginx)  
Объединил все машины в локальную сеть  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_config1_net3.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_config2_net3.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_config3_net3.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_config4_net3.JPG)

Далее установка и настройка `keepalived` на 2 серверах

Настраиваем конфиги `/etc/keepalived/keepalived.conf`  и разрешаем перенаправление трафика ipv4 `/etc/sysctl.conf`

***Конфиг мастера:***

```global_defs {
router_id LVS_1
}

vrrp_instance VI_1 {
state MASTER
interface eth1
virtual_router_id 230
nopreempt
priority 100
advert_int 1
authentication {
auth_type PASS
auth_pass password
}

virtual_ipaddress {
192.168.1.100/24
}
}

virtual_server 192.168.1.100 22 {
delay_loop 6
lb_algo rr
lb_kind DR
protocol TCP

real_server 192.168.1.11 {
weight 1
TCP_CHECK {
connect_timeout 3
}
}

real_server 192.168.1.22 80 {
weight 1
TCP_CHECK {
connect_timeout 3
}
```


***Конфиг резерва:***

```global_defs {
router_id uBACKUP
}

vrrp_instance VI_2 {
state BACKUP
interface eth1
virtual_router_id 230
nopreempt
priority 50
advert_int 1
authentication {
auth_type PASS
auth_pass password
}


virtual_ipaddress {
192.168.1.100/24
}
}
virtual_server 192.168.1.100 22 {
delay_loop 6
lb_algo rr
lb_kind DR
#persistence_timeout 50
protocol TCP

real_server 192.168.1.11 80 {
weight 1
TCP_CHECK {
connect_timeout 3
}
}

real_server 192.168.1.22 80 {
weight 1
TCP_CHECK {
connect_timeout 3
}
```
  
Стартуем демона `keepalived` на обеих нодах>    `systemctl start keepalived`

Проверяем, что служба стартанула без ошибок

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_servLB1_net3.JPG)  
на второй тоже ок, скрин не сделал)

***Начинаем тестить***

рубим интерфейс, на котором развернут мастер  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2test1.1_net3.JPG)

на второй ноде у нас шел пинг, он не прекращался, пакеты не потерялись. VIP перетек на резерв.  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2test1_net3.JPG)

смотрим, что виртуальный айпишник появился на резерве  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2test2_net3.JPG)

тут тоже визуально видно, что бэкап стал мастером.  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2test3_net3.JPG)

проверка, что балансировщик смотрим на оба app-сервера  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2test4_net3.JPG)

3. >В лекции мы использовали только 1 VIP адрес для балансировки. У такого подхода несколько отрицательных моментов, один из которых – невозможность активного использования нескольких хостов (1 адрес может только переехать с master на standby). Подумайте, сколько адресов оптимально использовать, если мы хотим без какой-либо деградации выдерживать потерю 1 из 3 хостов при входящем трафике 1.5 Гбит/с и физических линках хостов в 1 Гбит/с? Предполагается, что мы хотим задействовать 3 балансировщика в активном режиме (то есть не 2 адреса на 3 хоста, один из которых в обычное время простаивает).

нарисовал схемку вот такую. Визуально вроде все логично, по-моему мнению :)

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3_net3.JPEG)

Я думаю, что для супер-отказоустойчивого кластера нужно в DNS зарегать два VIP, на схеме они `192.168.1.99` и `192.168.1.98`.  
Keepalived будет одновременно работать как Мастер , так и бэкап. Если один из VIP упадет, он переедет на соседний сервак.  
И этого будет предостаточно, чтобы обработать весь трафик.  
