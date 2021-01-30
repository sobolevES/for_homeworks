> ####1.Какого типа команда cd?  
> ####Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.

vagrant@ubuntu-devops5:~$ type cd  
cd is a shell builtin

т.е. команда является встроенной в оболочку.  
На вопрос почему ей присвоен такой тип отвечу, что это как голая винда с минимальным обязательным набором драйверов, без которых ты сделать ничего не сможешь. +
 вызов команды из оболочки не так нагружает систему, т.к. вызывается напрямую.  
  Думаю можно было бы смело добавить команде cd тип function, т.к. мы же можем проверить, а есть ли у нас директория с таким именем?!

vagrant@ubuntu-devops5:/tmp$ cd r  
-bash: cd: r: No such file or directory

По факту мы вызвали функцию проверки наличия директории


> ####2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l?

vagrant@ubuntu-devops5:/opt/VBoxGuestAdditions-6.1.16$ grep software LICENSE | wc -l  
25  
vagrant@ubuntu-devops5:/opt/VBoxGuestAdditions-6.1.16$ grep -c -w software LICENSE
25

> ####3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

vagrant@ubuntu-devops5:/opt/VBoxGuestAdditions-6.1.16$ pstree -p 1  
systemd(1)

Системный процесс инициализации, который запускается ядром перед всеми последующими процессами. Главная задача отвечать за запуск и остановку системы.

> ####4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?

root@ubuntu-devops5:/dev/pts# tty  
/dev/pts/0  
root@ubuntu-devops5:/dev/pts# ls %%% 2>/dev/pts/1


это вывод в другой сессии:  
vagrant@ubuntu-devops5:~$ tty  
/dev/pts/1  
vagrant@ubuntu-devops5:~$ ls: cannot access '%%%': No such file or directory

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/4_terminal2.JPG)


> ####5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

vagrant@ubuntu-devops5:~$ touch file_1  
vagrant@ubuntu-devops5:~$ touch file_2  
vagrant@ubuntu-devops5:~$ ll > file_1  
vagrant@ubuntu-devops5:~$ grep -n "file" <file_1 >file_2  
vagrant@ubuntu-devops5:~$ cat file_2  
13:-rw-rw-r-- 1 vagrant vagrant       0 Jan 30 16:53 file_1  
14:-rw-rw-r-- 1 vagrant vagrant       0 Jan 30 16:53 file_2  
20:-rw-r--r-- 1 vagrant vagrant     807 Dec 23 07:52 .profile  

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5_terminal2.JPG)

> ####6. Получится ли вывести находясь в графическом режиме данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6.1_terminal.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6.2_terminal.JPG)

> ####7.Выполните команду bash 5>&1. К чему она приведет?


Мы создали новый файловый дескриптор 5 для баша и перенаправляем поток ввода-вывода на stdout(1).

> ####Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?

Мы берем stdin(0), в нашем случае "netology", и перенаправляем stdout на файловый дескриптор 5.  
Это происходит из-за того, что мы ранее переопределили файловый дескриптор для bash,  
т.е. мы сказали оболочке bash перенаправлять поток ввода-вывода на файловый дескриптор 5.

> ####8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?

vagrant@ubuntu-devops5:~$ ls /proc/$$/fd  
0  1  2  255  5  
vagrant@ubuntu-devops5:~$  
vagrant@ubuntu-devops5:~$  
vagrant@ubuntu-devops5:~$ ls  
1  2  6_hw  for_test  log_ls  nohup.out  stderr.log  stdout.log  test_dir  while.sh  
vagrant@ubuntu-devops5:~$ ls %%% log_ls 2>&1 1>&5 | grep -n "cannot access"  
log_ls  
1:ls: cannot access '%%%': No such file or directory

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/8_terminal2.JPG)

Вывели stdout на 5 дескриптор, а stderr передали в stdin через пайп для грепа.

> ####9.Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?

/proc/$$/environ  #содержит переменные для текущей сессии баша.


vagrant@ubuntu-devops5:/$ echo $$  
1648  
vagrant@ubuntu-devops5:/$ cat /proc/1648/environ

Можно так:  
vagrant@ubuntu-devops5:/$ cd /proc/$$/  
vagrant@ubuntu-devops5:/proc/3194$ set


> ####10. Используя man, опишите что доступно по адресам /proc/<'PID>/cmdline, /proc/<'PID>/exe.  
vagrant@ubuntu-devops5:/proc/1648$ man proc | less

/proc/<PID>/cmdline   #В нем хранится командная строка, которой был запущен данный процесс  
/proc/<PID>/exe       #Представляет собой символическую ссылку на исполняемый файл, который инициировал запуск процесса.

> ####11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo  
4_2

vagrant@ubuntu-devops5:/proc/1648$ cat /proc/cpuinfo | grep sse  
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2  
ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 sse4_1 sse4_2 x2apic movbe popcnt rdrand hypervisor lahf_lm 3dnowprefetch pti

Ну либо так, как говорится в man proc:  
vagrant@ubuntu-devops5:/proc/1648$ lscpu | grep sse  
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology  
nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 sse4_1 sse4_2 x2apic movbe popcnt rdrand hypervisor lahf_lm 3dnowprefetch pti

>####12. vagrant@netology1:~$ ssh localhost 'tty'  
>####not a tty  
>####Почитайте, почему так происходит, и как изменить поведение.

По умолчанию, при запуске команд на удаленной рс при помощи ssh, tty не выделяется для удаленного сеанса.


В  man ssh  прочитал про флаг -t  
vagrant@ubuntu-devops5:~$ man ssh | grep -A 2 "Force pseudo-terminal"

Вот так смог изменить поведение:

vagrant@ubuntu-devops5:~$ ssh -t localhost tty "$(<while.sh)"  
vagrant@localhost's password:  
/dev/pts/4  
1   2   6_hw   echo   file_1   file_2   for_test   log_ls   nohup.out   stderr.log   stdout.log   test_dir  'test test test'   while.sh  
ls: cannot access '%': No such file or directory  


>####13.Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr.  
>####Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.

![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/13_terminal2.JPG)


>####14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а,  
>####который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file.   
>####Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.

Файл принадлежит руту и sudo не умеет выполнять перенаправление вывода.  
Команда tee получит вывод команды echo, повысит права на sudo и запишет в файлик, который принадлежит другому пользователю, т.е. руту.  



