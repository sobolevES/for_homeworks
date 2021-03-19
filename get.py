#!/usr/bin/env python3

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
