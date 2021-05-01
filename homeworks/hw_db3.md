1. >Используя `docker` поднимите инстанс `MySQL` (версию 8). Данные БД сохраните в `volume`.  
Изучите бэкап БД и восстановитесь из него.  
Перейдите в управляющую консоль mysql внутри контейнера.  
Используя команду `\h` получите список управляющих команд.  
Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.  
Подключитесь к восстановленной БД и получите список таблиц из этой БД.  
Приведите в ответе количество записей с `price > 300`.  
В следующих заданиях мы будем продолжать работу с данным контейнером.  
  
```
docker exec -ti mysql_mysql_db_1 bash
mysql -u root -p -e "create database test_mysql";
mysql -u root -p test_mysql < /opt/mysql/volume2/backup/test_dump.sql
mysql -u root -p test_mysql
```
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1_db3.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.1_db3.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.2_db3.JPG)  
  
2. >Создайте пользователя `test` в БД c паролем `test-pass`, используя:  
-плагин авторизации `mysql_native_password`  
-срок истечения пароля - 180 дней  
-количество попыток авторизации - 3  
-максимальное количество запросов в час - 100  
аттрибуты пользователя:  
-Фамилия "Pretty"  
-Имя "James"  
Предоставьте привелегии пользователю test на операции `SELECT базы test_db`.  
Используя таблицу `INFORMATION_SCHEMA.USER_ATTRIBUTES` получите данные по пользователю `test` и приведите в ответе к задаче.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_db3.JPG)  
  
3. >Установите профилирование `SET profiling = 1`. Изучите вывод профилирования команд `SHOW PROFILES;`.  
Исследуйте, какой engine используется в таблице БД `test_db` и приведите в ответе.  
Измените `engine` и приведите время выполнения и запрос на изменения из профайлера в ответе:  
-на `MyISAM`  
-на `InnoDB`  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.1_db3.JPG)  
  
смена движка на `MyISAM`:  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.2_db3.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.3_db3.JPG)  
  
смена движка на `InnoDB`:  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.4_db3.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.5_db3.JPG)  
  
4. >Изучите файл `my.cnf` в директории `/etc/mysql`.  
Измените его согласно ТЗ (движок `InnoDB`):  
-Скорость IO важнее сохранности данных  
-Нужна компрессия таблиц для экономии места на диске  
-Размер буффера с незакомиченными транзакциями 1 Мб 
-Буффер кеширования 30% от ОЗУ  
-Размер файла логов операций 100 Мб  
Приведите в ответе измененный файл my.cnf.  
  
```
root@728fa60788e3:/etc/mysql# cat my.cnf

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 300M
innodb_log_file_size = 100M

!includedir /etc/mysql/conf.d/
```
  
Это ответ почему размер буфера кэширования установлен 300мб,  округлил для феншуя:   
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4.1_db3.JPG)  



