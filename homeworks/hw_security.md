1. >Установите `Hashicorp Vault` в виртуальной машине `Vagrant/VirtualBox`. Это не является обязательным для выполнения задания, но для лучшего понимания что происходит при выполнении команд (посмотреть результат в UI), можно по аналогии с netdata из прошлых лекций пробросить порт `Vault` на `localhost`:  
   `config.vm.network "forwarded_port", guest: 8200, host: 8200`  
   Однако, обратите внимание, что только-лишь проброса порта не будет достаточно – по-умолчанию `Vault` слушает на `127.0.0.1`; добавьте к опциям запуска `-dev-listen-address="0.0.0.0:8200"`.

Поднял службу, настроил юнит-файл, в exec прописал что нужно ему слушать

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.1_security.JPG)

Проверка, что UI поднялся

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.2_security.JPG)

2. >Запустить Vault-сервер в dev-режиме (дополнив ключ `-dev упомянутым выше `-dev-listen-address`, если хотите увидеть UI).

Тут я понял, что править юнит файл мне надоело и начал запускать напрямую и еще с ключиком ..root.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_security.JPG)

Проверяем UI админский  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.2_security.JPG)

Т.к. мы запустили с опцией ...root, то после поднятия сервиса токен=root, авторизуемся по нему  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.3_security.JPG)

3. >Используя `PKI Secrets Engine`, создайте `Root CA` и `Intermediate CA`. Обратите внимание на дополнительные материалы по созданию `CA` в `Vault`, если с изначальной инструкцией возникнут сложности.

Насоздавался от души

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.1_security.JPG)

4. >Согласно этой же инструкции, подпишите Intermediate CA csr на сертификат для тестового домена (например, netology.example.com если действовали согласно инструкции).

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4.1_security.JPG)

5. >Поднимите на `localhost nginx`, сконфигурируйте `default vhost` для использования подписанного `Vault Intermediate CA` сертификата и выбранного вами домена. Сертификат из `Vault` подложить в `nginx` руками.

тут в принципе ничего нового..  
установка, настройка юнит-файла, поднятие демона.
ну и в вагрант-файле сделал проброс портов  
  `config.vm.network "forwarded_port", guest: 80, host: 80`  
  `config.vm.network "forwarded_port", guest: 443, host: 443`

Поднял nginx  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5.1_security.JPG)

Далее не стал подкладывать серты в /etc/nginx/certs/ вручную, а решил попробовать консул, как никак че то новенькое :)

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5.6_security.JPG)

создал шаблоны, которые будет использовать консул

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5.5_security.JPG)

Создал юнит для консула  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5.7_security.JPG)

Ну и старт демона

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5.4_security.JPG)

Результат вот такой

Корневой орет конечно, надо было его в доверенные на лок машину закинуть  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5.2_security.JPG)

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5.3_security.JPG)

6. >Модифицировав `/etc/hosts` и системный `trust-store`, добейтесь безошибочной с точки зрения `HTTPS` работы `curl` на ваш тестовый домен (отдающийся с `localhost`). Рекомендуется добавлять в доверенные сертификаты `Intermediate CA`. `Root CA` добавить было бы правильнее, но тогда при конфигурации `nginx` потребуется включить в цепочку `Intermediate`, что выходит за рамки лекции. Так же, пожалуйста, не добавляйте в доверенные сам сертификат хоста.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6_security.JPG)

7. >Ознакомьтесь с протоколом `ACME` и `CA Let's encrypt`. Если у вас есть во владении доменное имя с платным TLS-сертификатом, который возможно заменить на LE, или же без HTTPS вообще, попробуйте воспользоваться одним из предложенных клиентов, чтобы сделать веб-сайт безопасным (или перестать платить за коммерческий сертификат).

Почитал, классно конечно, что хоть кто то бесплатно что то дает :)  
Установил себе на виртуалку сертбот, поконфигурировал его, но доменных имен у меня нету, поэтому конфигурирвоание закончилось)  
Статей тьма где описывается процесс, я читал и ориентировался на эту https://habr.com/ru/post/318952/  



