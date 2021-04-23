1. >В данном задании вы научитесь изменять существующие Dockerfile, адаптируя их под нужный инфраструктурный стек.  
Измените базовый образ предложенного Dockerfile на Arch Linux c сохранением его функциональности.  
Для получения зачета, вам необходимо предоставить:  
-Написанный вами Dockerfile
-Скриншот вывода командной строки после запуска контейнера из вашего базового образа
-Ссылку на образ в вашем хранилище docker-hub

--- 
```
FROM archlinux:latest

RUN useradd -m notroot

RUN pacman -Syy --noconfirm && \
    pacman -Sy --noconfirm git base-devel && \
    pacman -Syu --noconfirm && \
    pacman -Sy --noconfirm ponysay

RUN echo "notroot ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/notroot

USER notroot
WORKDIR /home/notroot

RUN git clone https://aur.archlinux.org/yay-git && \
    cd yay-git && \
    makepkg --noconfirm --syncdeps --rmdeps --install

WORKDIR /pkg
ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
```
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1_docker2.JPG)  
  
https://hub.docker.com/repository/docker/soboleves/arch.ponysay  

###################################################################  
###########################   Доработка  -#############################  
###################################################################  

На самом деле у меня не было ошибок ни при билде образа, ни при старте контейнера, ну ок.
  
Прочитал про этот баг и как его можно пофиксить  тут:  
https://github.com/qutebrowser/qutebrowser/commit/478e4de7bd1f26bebdcdc166d5369b2b5142c3e2  
  
пересобрал образ, поднял контейнер с новым конфигом  
 
``` 
FROM archlinux:latest

RUN useradd -m notroot

RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xvf "$patched_glibc"

RUN pacman -Syy --noconfirm && \
    pacman -Sy --noconfirm git base-devel && \
    pacman -Syu --noconfirm && \
    pacman -Sy --noconfirm ponysay

RUN echo "notroot ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/notroot

USER notroot
WORKDIR /home/notroot

RUN git clone https://aur.archlinux.org/yay-git && \
    cd yay-git && \
    makepkg --noconfirm --syncdeps --rmdeps --install

WORKDIR /pkg
ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
```
  
v4
https://hub.docker.com/repository/docker/soboleves/arch.ponysay
 
###################################################################  
###################################################################  
################################################################### 
  
2. >В данной задаче вы составите несколько разных `Dockerfile` для проекта `Jenkins`, опубликуем образ в `dockerhub.io` и посмотрим логи этих контейнеров.  
   Для получения зачета, вам необходимо предоставить:  
-Наполнения 2х `Dockerfile` из задания  
-Скриншоты логов запущенных вами контейнеров (из командной строки)  
-Скриншоты веб-интерфейса `Jenkins` запущенных вами контейнеров (достаточно 1 скриншота на контейнер)  
-Ссылки на образы в вашем хранилище `docker-hub`  

---
```
FROM ubuntu:latest

RUN apt-get update && \
    apt install -y openjdk-11-jdk openjdk-11-jre

RUN apt install -y wget gnupg2 git && \
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add - && \
    sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

RUN apt-get update && \
    apt-get install -y jenkins

EXPOSE 8080

RUN service jenkins start

ENTRYPOINT ["/bin/bash"]
```
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_docker2.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.2_docker2.JPG)  
  
https://hub.docker.com/repository/docker/soboleves/ubuntu.jenkins  

```
FROM amazoncorretto

RUN yum update && yum install -y git wget initscripts

RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo

RUN rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key

RUN yum update && yum install jenkins -y

EXPOSE 8080

RUN service jenkins start

ENTRYPOINT ["/bin/bash"]
```
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.3_docker2.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.4_docker2.JPG)  
  
https://hub.docker.com/repository/docker/soboleves/amazoncorretto.jenkins  

###################################################################  
###########################   Доработка  -#############################  
###################################################################  

поднимаю контейнер так:  
docker run -itd --name <имя_контейнера> -p 8080:8080 <имя_образа>   

ver2  
https://hub.docker.com/repository/docker/soboleves/amazoncorretto.jenkins  

```
FROM amazoncorretto

RUN yum update && yum install -y git wget initscripts

RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo

RUN rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key

RUN yum update && yum install jenkins -y

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "/etc/init.d/jenkins start && /bin/bash"]
```
  
  
ver3  
https://hub.docker.com/repository/docker/soboleves/ubuntu.jenkins

```
FROM ubuntu:latest

RUN apt-get update && \
    apt install -y openjdk-11-jdk openjdk-11-jre

RUN apt install -y wget gnupg2 git && \
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add - && \
    sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

RUN apt-get update && \
    apt-get install -y jenkins

EXPOSE 8080

ENTRYPOINT ["/bin/sh", "-c", "service jenkins start && /bin/bash"]
```
###################################################################  
###################################################################  
###################################################################  

3. >В данном задании вы научитесь:  
-объединять контейнеры в единую сеть  
-исполнять команды "изнутри" контейнера  
Для получения зачета, вам необходимо предоставить:  
-Наполнение Dockerfile с npm приложением  
-Скриншот вывода вызова команды списка docker сетей (docker network cli)  
-Скриншот вызова утилиты curl с успешным ответом  

---
```
FROM node:lts-alpine3.13

RUN mkdir -p /home/vagrant/node_project && chown -R node:node /home/vagrant/node_project

WORKDIR /home/vagrant/node_project

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node","server.js"]
```

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3_docker2.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.1_docker2.JPG)  

