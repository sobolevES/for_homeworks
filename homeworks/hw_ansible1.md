1. >Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.  
  
`root@vagrant:/media/sf_playbook# ansible-playbook -i inventory/test.yml site.yml`  
some_fact = "msg": 12  
  
2. >Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.  
  
`root@vagrant:/media/sf_playbook# vim group_vars/all/examp.yml`  
Заменил 12 на 'all default fact'  
  
3. >Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.
  
`root@vagrant:/media/sf_playbook# docker run --name centos7 -d pycontribs/centos:7 sleep 600000`  
`root@vagrant:/media/sf_playbook# docker run --name ubuntu -d pycontribs/ubuntu:latest sleep 600000`  
  
4. >Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.  
  
```
ok: [centos7] => {
    "msg": "el"
}  
ok: [ubuntu] => {
    "msg": "deb"
}
```  
  
5. >Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.  
  
```
root@vagrant:/media/sf_playbook# vim group_vars/deb/examp.yml
deb заменил на 'deb default fact'
root@vagrant:/media/sf_playbook# vim group_vars/el/examp.yml
el заменил на 'el default fact'
```
  
6. >Повторите запуск `playbook` на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.  
  
`root@vagrant:/media/sf_playbook# ansible-playbook -i inventory/prod.yml site.yml`  
  
```
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```
  
7. >При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.  
 
```
root@vagrant:/media/sf_playbook# cd group_vars/deb
root@vagrant:/media/sf_playbook/group_vars/deb# ansible-vault encrypt examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful

root@vagrant:/media/sf_playbook/group_vars# cd el
root@vagrant:/media/sf_playbook/group_vars/el#
root@vagrant:/media/sf_playbook/group_vars/el# ansible-vault encrypt examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```
  
8. >Запустите `playbook` на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.  
  
`root@vagrant:/media/sf_playbook# ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass`  
  
9. >Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.  
  
Список Connection-плагинов не велик)  Видимо имеется ввиду local, который используется для запуска команд локально на машине управления.  
  
10. >В `prod.yml` добавьте новую группу хостов с именем `local`, в ней разместите `localhost` с необходимым типом подключения.  
  
```
root@vagrant:/media/sf_playbook# cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
root@vagrant:/media/sf_playbook#
```
  
```
root@vagrant:/media/sf_playbook/group_vars# mkdir local
root@vagrant:/media/sf_playbook/group_vars# vim local/nano examp.yml

---
  some_fact: "local"
```
  
11. >Запустите `playbook` на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1_ansible1.JPG)  
  
12. >Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.  
    
https://github.com/sobolevES/for_homeworks/tree/main/playbook