1. >Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose манифест.
  
```
version: '3.1'

services:
  postgres_db:
    image: postgres:12
    restart: always
    environment:
      - POSTGRES_PASSWORD=root
      - POSTGRES_USER=root
      - POSTGRES_DB=stage
    volumes:
      - ./volume1/data:/var/lib/postgresql/volume1/data
      - ./volume2/backup:/var/lib/postgresql/volume2/backup
    ports:
      - ${POSTGRES_PORT:-5432}:5432
```
  
2. >В БД из задачи 1:  
-создайте пользователя test-admin-user и БД test_db  
-в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)  
-предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db  
-создайте пользователя test-simple-user  
-предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db  
**Таблица orders:**  
-id (serial primary key)  
-наименование (string)  
-цена (integer)  
**Таблица clients:**  
-id (serial primary key)  
-фамилия (string)  
-страна проживания (string, index)  
-заказ (foreign key orders)  
**Приведите:**  
-итоговый список БД после выполнения пунктов выше,  
-описание таблиц (describe)  
-SQL-запрос для выдачи списка пользователей с правами над таблицами test_db  
-список пользователей с правами над таблицами test_db  

  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.2_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.3_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.4_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.5_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.6_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.7_db2.JPG)  
  

3. >Используя SQL синтаксис - наполните таблицы следующими тестовыми данными...  
Используя SQL синтаксис:  
-вычислите количество записей для каждой таблицы  
-приведите в ответе:  
 --запросы  
 --результаты их выполнения.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.1_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.2_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.3_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.4_db2.JPG)  
  ###################################################  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.5_db2.JPG)  
  
4. >Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
Используя foreign keys свяжите записи из таблиц, согласно таблице:
  
Тут я понял, что для работы с внешним ключом мне нужна еще одна колонка, по которой я смогу связывать таблицы, т.к. по наименованию - это плохая практика, однофамильцы, регистр и т.п.
по id одной таблицы c id другой тоже как то мне показалось не очень   
  
создал колонку id_zakaz, и связал ее с колонкой id ордерс.
  
`alter table clients
add CONSTRAINT zakaz FOREIGN key (id_zakaz) references orders (id);`
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4_db2.JPG)  
  
5. >Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).  
Приведите получившийся результат и объясните что значат полученные значения.
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5_db2.JPG)  
  
```
Hash Join  (cost=1.11..19.41 rows=5 width=216) (actual time=0.074..0.080 rows=3 loops=1)  #--Hash Join используется для объединения двух наборов записей. Сначала Hash Join вызывает “Hash", который в свою очередь вызывает Seq Scan по clients. Потом Hash создает в памяти (или на диске – в зависимости от размера) хэш/ассоциативный массив/словарь со строками из источника, хэшированными с помощью того, что используется для объединения данных (в нашем случае это столбец c.id_zakaz в clients). Затем Hash Join запускает вторую субоперацию Seq Scan по orders и для каждой строки из неё проверяет есть ли ключ join o.id в хэше, возвращенном операцией Hash, Если нет, данная строка из субоперации игнорируется (не будет возвращена), Если ключ существует, Hash Join берет строки из хэша и, основываясь на этой строке, с одной стороны, и всех строках хэша, с другой стороны, генерирует вывод строк.
  Hash Cond: (o.id = c.id_zakaz)  #--хэш с набором объединяемых записей
  ->  Seq Scan on orders o  (cost=0.00..16.00 rows=600 width=102) (actual time=0.023..0.025 rows=5 loops=1)  #--последовательное чтение данных таблицы "orders" блок за блоком.  Cost - это значение затратности операции. Первое значение 0.00 - затраты на получение первой строки. Второе — 16.00 — затраты на получение всех строк. Rows - приблизительное кол-во возвращаемых строк планировщиком при выполнении операции Seq Scan. У нас оно 600. width — средний размер одной строки в байтах. actual time — реальное время в миллисекундах, затраченное для получения первой строки и всех строк соответственно. Rows — реальное количество строк, полученных при Seq Scan. loops — сколько раз пришлось выполнить операцию Seq Scan. 
  ->  Hash  (cost=1.05..1.05 rows=5 width=122) (actual time=0.032..0.033 rows=3 loops=1) #--вначале описал.
        Buckets: 1024  Batches: 1  Memory Usage: 9kB  #--показывает количество сегментов хэша 1024 и пакетов 1, а также максимальный объем памяти, используемой для хэш-таблицы 9kB 
        ->  Seq Scan on clients c  (cost=0.00..1.05 rows=5 width=122) (actual time=0.020..0.024 rows=5 loops=1) #--последовательное чтение данных таблицы "clients". Остальное все как про ордерс.
Planning Time: 0.431 ms   #--сколько времени потребовалось планировщику для осмысления запроса и создания плана выполнения
Execution Time: 0.127 ms  #--сколько времени выполнялся составленный план запроса
```

6. >Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).  
Остановите контейнер с PostgreSQL (но не удаляйте volumes).  
Поднимите новый пустой контейнер с PostgreSQL.  
Восстановите БД test_db в новом контейнере.  
Приведите список операций, который вы применяли для бэкапа данных и восстановления.  
    
```
pg_dump -Fc -U root test_db -f /var/lib/postgresql/volume2/backup/test_db3.dump
```
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6.4_db2.JPG)  
  

```
docker-compose down
docker-compose up -d
docker exec -ti postgres_sql_postgres_db_1 bash
createdb test_db -O root
pg_restore -d test_db -U root /var/lib/postgresql/volume2/backup/test_db3.dump
```
Все вроде ничего, я вижу, что абсолютно все переехало, под рутом все отлично работает, а вот доп учетки/роли отвалились, хотя в бэкапе гранты есть.  
pg_restore: warning: errors ignored on restore  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6.5_db2.JPG)  
  ###################################################    
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6.6_db2.JPG)  







