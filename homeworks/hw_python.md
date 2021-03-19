1. > `a = 1; b = '2';c = a + b`  
   Какое значение будет присвоено переменной c?  
   Как получить для переменной c значение 12?   
   Как получить для переменной c значение 3?

c - никакое не будет присвоено, т.к. разный тип переменных. type(a)<class 'int'>   type(b)<class 'str'>  
чтобы получить 12 нужно чтобы обе переменные были стринговые. a = '1', b = '2'  
чтобы получить 3 нужно, чтобы обе переменные были интовые. a = 1, b = 2  

2. >Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
  
```#!/usr/bin/env python

import os

bash_command = ["cd /media/sf_repository", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        abs_path = os.path.abspath(prepare_result)
        print(abs_path)
```

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_python.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_python.JPG)

3. >Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

```#!/usr/bin/env python3

import os

repo_path = input("В каком репо будем смотреть? \n")
bash_command = ["cd " + repo_path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        abs_path = os.path.abspath(prepare_result)
        print(abs_path)
```

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3_python.JPG)

4. >Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

```#!/usr/bin/env python3

import os
import socket
import sys
import subprocess

hostnames = {'drive.google.com': '64.233.164.194', 'mail.google.com': '64.233.165.19', 'google.com': '64.233.165.113'}

for hostname, value in hostnames.items():
#    print(hostname)
    try:
        ip = socket.gethostbyname(hostname)
        #print(f'The {hostname} IP Address is {ip}')
        if value == ip:
            print(f'{hostname}: IP {value} в словаре и последний полученный {ip} СОВПАДАЮТ, все ок не трогаем')
        else:
            print(f'{hostname}:  IP {value} в словаре и последний полученный {ip} НЕ_СОВПАДАЮТ, надо апдейтить')
            hostnames[hostname] = ip
    except socket.gaierror as e:
        print(f'{hostname} >> Не резолвится {e}')
print(f'TEST, что все заапдейтилось {hostnames}')
```

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4_python.JPG)  