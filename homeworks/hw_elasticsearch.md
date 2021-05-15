1. >В этом задании вы потренируетесь в:  
-установке `elasticsearch`  
-первоначальном конфигурировании `elastcisearch`  
-запуске `elasticsearch` в `docker`  
Используя докер образ `centos:7` как базовый и документацию по установке и запуску `Elastcisearch`:  
-составьте `Dockerfile`-манифест для `elasticsearch`  
-соберите `docker`-образ и сделайте push в ваш `docker.io` репозиторий  
-запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины  
Требования к `elasticsearch.yml`:  
-данные path должны сохраняться в `/var/lib`  
-имя ноды должно быть `netology_test`  
В ответе приведите:  
-текст `Dockerfile` манифеста  
-ссылку на образ в репозитории `dockerhub`  
-ответ `elasticsearch` на запрос пути / в `json` виде  
Подсказки:  
возможно вам понадобится установка пакета `perl-Digest-SHA` для корректной работы пакета `shasum`  
при сетевых проблемах внимательно изучите кластерные и сетевые настройки в `elasticsearch.yml`  
при некоторых проблемах вам поможет docker директива `ulimit`  
`elasticsearch` в логах обычно описывает проблему и пути ее решения  
Далее мы будем работать с данным экземпляром `elasticsearch`.  

```
FROM centos:7
MAINTAINER elastic
ENV ES_VER=7.12.1
RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000
RUN yum -y install wget rpm vim curl net-tools perl-Digest-SHA
RUN yum -y install java-1.8.0-openjdk.x86_64
RUN mkdir -p /var/log/elasticsearch && chmod -R 755 /var/log/elasticsearch && chmod 755 /var/log && chown -R elasticsearch:elasticsearch /var/log/elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-linux-x86_64.tar.gz
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-linux-x86_64.tar.gz.sha512
RUN shasum -a 512 -c elasticsearch-7.12.1-linux-x86_64.tar.gz.sha512
RUN tar -xzf elasticsearch-7.12.1-linux-x86_64.tar.gz
RUN chmod -R u=rwx,g=rx,o=rx /elasticsearch-7.12.1 && chown -R elasticsearch:elasticsearch /elasticsearch-7.12.1
COPY elasticsearch.yml /elasticsearch-7.12.1/config/elasticsearch.yml
RUN cd elasticsearch-7.12.1/
USER elasticsearch:elasticsearch
EXPOSE 9200
EXPOSE 9300
CMD ["/elasticsearch-7.12.1/bin/elasticsearch"]
```
  
```
docker network create somenetwork  
docker build -t elastic -f dockerfile_elastic .  
docker run -itd --name elastic --net somenetwork -p 9200:9200 -p 9300:9300 elastic  
```
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.1_elasticsearch.JPG)  
  
https://hub.docker.com/repository/docker/soboleves/centos7.elastic
  
2. >В этом задании вы научитесь:  
-создавать и удалять индексы  
-изучать состояние кластера  
-обосновывать причину деградации доступности данных  
Ознакомтесь с документацией и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:  
Имя	Репл 	Шард  
ind-1	0	1  
ind-2	1	2  
ind-3	2	4  
Получите список индексов и их статусов, используя API и приведите в ответе на задание.  
Получите состояние кластера elasticsearch, используя API.  
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?  
Удалите все индексы.  
Важно  
При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.  

```
curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}
'


curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 2,  
      "number_of_replicas": 1 
    }
  }
}
'


curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "index": {
      "number_of_shards": 4,  
      "number_of_replicas": 2 
    }
  }
}
'
```
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_elasticsearch.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.2_elasticsearch.JPG)  
    
У нас одна нода, а т.к. elasticsearch - это отказоустойчивая система, то эластик понимает, что мы мы создали 2 индекса для более чем одной реплики, которых у нас нет.  
Поэтому и красит индексы в желтый. А кластер красится из-за индексов, берет худжее состояние.   
  
```
curl -X DELETE "localhost:9200/ind-1?pretty"  
curl -X DELETE "localhost:9200/ind-2?pretty"  
curl -X DELETE "localhost:9200/ind-3?pretty"  
```
  
3. >В данном задании вы научитесь:  
-создавать бэкапы данных  
-восстанавливать индексы из бэкапов  
Создайте директорию {путь до корневой директории с `elasticsearch` в образе}`/snapshots`.  
Используя API зарегистрируйте данную директорию как `snapshot repository` c именем `netology_backup`.  
Приведите в ответе запрос API и результат вызова API для создания репозитория.  
Создайте `индекс test` с 0 реплик и 1 шардом и приведите в ответе список индексов.  
Создайте `snapshot` состояния кластера `elasticsearch`.  
Приведите в ответе список файлов в директории со snapshotами.  
Удалите `индекс test` и создайте `индекс test-2`. Приведите в ответе список индексов.  
Восстановите состояние кластера `elasticsearch` из `snapshot`, созданного ранее.  
Приведите в ответе запрос к API восстановления и итоговый список индексов.  
Подсказки:  
возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`  
  

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.1_elasticsearch.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.2_elasticsearch.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.3_elasticsearch.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.4_elasticsearch.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.5_elasticsearch.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.6_elasticsearch.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.7_elasticsearch.JPG)  
  
