#!/usr/bin/env python3

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
