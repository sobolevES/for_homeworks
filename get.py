#!/usr/bin/env python3

import os
import socket
import sys
import subprocess
import json
import yaml

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

#with open('hostnames_2.json', 'w', encoding='utf8') as write_json2:
#json.dump(dict_items, write_json2)
##json_string = json.dumps(dict_items)
#print(f'JSON_из преобразованного >>> записали сюда {os.getcwd()}/hostnames_2.json')

#list_hostnames = []
##for i in range(1):
#list_hostnames.append(hostnames)
#dict_items = hostnames.items()
#print(f'Это список:  {dict_items}')

with open('hostnames.json', 'w', encoding='utf8') as write_json:
    json.dump(hostnames, write_json)
#json_string = json.dumps(hostnames)
print(f'JSON >>> записали сюда {os.getcwd()}/hostnames.json')

to_yml = {'host/ip': [hostnames]}
with open('hostnames.yaml', 'w', encoding='utf8') as write_yaml:
    yaml.dump(to_yml, write_yaml, default_flow_style=False, allow_unicode=True)
print(f'YAML >>> записали сюда {os.getcwd()}/hostnames.yaml')
#file.write(yml.replace('\n', ' - \n'))

