1. >Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.  
Подключитесь к БД PostgreSQL используя `psql`.  
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.  
Найдите и приведите управляющие команды для:  
-вывода списка БД  
-подключения к БД  
-вывода списка таблиц  
-вывода описания содержимого таблиц  
-выхода из `psql`  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1_db4.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.1_db4.JPG)  
  
2. >Используя psql создайте БД `test_database`.  
Изучите бэкап БД.  
Восстановите бэкап БД в `test_database`.  
Перейдите в управляющую консоль psql внутри контейнера.  
Подключитесь к восстановленной БД и проведите операцию `ANALYZE` для сбора статистики по таблице.  
Используя таблицу `pg_stats`, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.  
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_db4.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.2_db4.JPG)  
  
3. >Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время.  
Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).  
Предложите SQL-транзакцию для проведения данной операции.  
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы `orders`?  
  

Если без включения секционирования на нашей действующей таблице, то можно применить вот такой способ (Наследование таблиц (INHERITS)):  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.1_db4.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.2_db4.JPG)   
    
Ну а далее создание функции для инсерта и триггера для вызова этой функции.  
  
  
Если применить декларативный подход (PARTITION), то так:  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.3_db4.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.4_db4.JPG)   
  
Возможно правильным решением на начальной стадии было бы:   
1. Включить Секционирование для таблицы  
2. Создать триггер, который бы срабатывал на каждую вставку в таблицу orders и при необходимости сам создавал нам партиции.  
  
4. >Используя утилиту pg_dump создайте бекап БД `test_database`.  
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?  
  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4.1_db4.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4.2_db4.JPG)  

