1. >Мы выгрузили JSON, который получили через API запрос к нашему сервису. Нужно найти и исправить все ошибки, которые допускает наш сервис.

```
{ "info": "Sample JSON output from our service\t",
    "elements": [
	{
        "name": "first",
        "type": "server",
        "ip": 7175 
        },
        { 
        "name": "second",
        "type": "proxy",
        "ip": "71.78.22.43"
        }
    ]
}
```

2. >В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

```
#!/usr/bin/env python3

import socket
import os
import json
import yaml

hostnames = {'drive.google.com': '64.233.164.194', 'mail.google.com': '64.233.165.19', 'google.com': '64.233.165.113'}

for hostname, value in hostnames.items():
    try:
        ip = socket.gethostbyname(hostname)
        #print(f'The {hostname} IP Address is {ip}')
        if value == ip:
            print(f'{hostname}: IP {value} в словаре и последний полученный {ip} СОВПАДАЮТ, все ок не трогаем')
        else:
            print(f'{hostname}:  IP {value} в словаре и последний полученный {ip} НЕ_СОВПАДАЮТ, надо апдейтить')
            hostnames[hostname] = ip
    except socket.gaierror as e:
        hostnames[hostname] = None
        print(f'[ERROR] {hostname} не резолвится {e}')
print(f'DICT update >>> {hostnames}')

host_obj_list = [{hostname: value} for hostname, value in hostnames.items()]

with open('hostnames.json', 'w', encoding='utf8') as write_json2:
    json.dump(host_obj_list, write_json2)
print(f'JSON >>> записали сюда {os.getcwd()}/hostnames.json')

with open('hostnames.yml', 'w', encoding='utf8') as write_yaml2:
    yaml.dump(host_obj_list, write_yaml2, default_flow_style=False, allow_unicode=True)
print(f'YAML >>> записали сюда {os.getcwd()}/hostnames.yml')
```
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_json-yml.JPG)  