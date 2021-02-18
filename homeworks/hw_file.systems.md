1. >Узнайте о `sparse` (разряженных) файлах.

Основная задача разреженных файлов - это экономия места. Они занимают меньше места, чем их реальный размер.   
Это достигается путем освобождения области, которая занята нулями 0x00.  
Как только при считывании файла мы дойдем до области с нулями, система прочитает нули, но реального чтения с диска не  
произойдет.

Попробовал создать разреженный файл размером 5мб:  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.1_file.systems.JPG)

Преобразовать обычный файл в разреженный:  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.2_file.systems.JPG)  
но тут у меня файлик легкий и видимо без нулей, поэтому размер не изменился,либо я чего то не понял )

2. >Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Нет. жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.  
Различаются только имена файлов. Можно сказать, что жесткая ссылка это еще одно имя для файла.

СОздал для примера жесткую ссылку, видно, что права/владелец/inode у них одинаковый.  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_file.systems.JPG)

Попробовал изменить владельца у исходника, автоматом меняется и у жесткой ссылки:  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.2_file.systems.JPG)

3. >...создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

VM поднялась  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.1_file.systems.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.2_file.systems.JPG)

4. >Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

`vagrant@vagrant:~$ fdisk /dev/sdb`  
и погнали клацать что нас спрашивает система)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4_file.systems.JPG)

5. >Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

`root@vagrant:/home/vagrant# sfdisk -d /dev/sdb | sfdisk /dev/sdc`  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/3.2_file.systems.JPG)

6. >Соберите `mdadm` RAID1 на паре разделов 2 Гб.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6_file.systems.JPG)

7. >Соберите `mdadm` RAID0 на второй паре маленьких разделов.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/7_file.systems.JPG)

8. >Создайте 2 независимых PV на получившихся md-устройствах.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/8_file.systems.JPG)

9. >Создайте общую `volume-group` на этих двух PV.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/9.1_file.systems.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/9.2_file.systems.JPG)

10. >Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/10_file.systems.JPG)

11. >Создайте `mkfs.ext4` ФС на получившемся LV.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/11_file.systems.JPG)

12. >Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/12_file.systems.JPG)

13. >Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/13_file.systems.JPG)

14. >Прикрепите вывод `lsblk`.  
    ![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/14_file.systems.JPG)

15. >Протестируйте целостность файла.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/15_file.systems.JPG)

16. >Используя `pvmove`, переместите содержимое PV с RAID0 на RAID1.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/16_file.systems.JPG)

17. >Сделайте `--fail` на устройство в вашем RAID1 md.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/17_file.systems.JPG)

18. >Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/18_file.systems.JPG)

19. >Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/19_file.systems.JPG)

20. >Погасите тестовый хост, `vagrant destroy`

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/20_file.systems.JPG)  

