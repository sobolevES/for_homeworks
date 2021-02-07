1. >Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее, вы можете запустить strace на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.1_OS1.JPG)   
  
2. >Попробуйте использовать команду file на объекты разных типов на файловой системе. Например:  
   vagrant@netology1:~$ `file /dev/tty`   
   /dev/tty: character special (5/0)  
   vagrant@netology1:~$ `file /dev/sda`  
   /dev/sda: block special (8/0)  
   vagrant@netology1:~$ `file /bin/bash`  
   /bin/bash: ELF 64-bit LSB shared object, x86-64  
   > Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2_OS1.JPG)
  
3. >Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).  
   
Из моей практики был пример когда в разделе /var было выделено всего 10гб, а докер и монго сожрали все место и останавливать было не вариант, дак вот
мне помог самый простой способ обнуления лога:  
: `> file.log`  (ну под судо ествественно)  
  
А вот если приклад пишет в файл, которого нет, то думаю можно такой алгоритм применить:  
Найти убитый удаленный файл его пид и десриптор  
`find /proc/*/fd -ls | grep  '(deleted)'`    
ну либо так `lsof -nP | grep '(deleted)'`    
А далее уже обнуляем stdout&stderr на этом файловом дескрипторе.  
: `> "/proc/$pid/fd/$fd"`  
Если надо перенаправить поток найденного дескриптора 1>&($fd) /dev/null

4. >Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?  

Зомби-процессы - это в первую очередь мертвые процессы.  
По факту это записи в таблице процессов ядра.  
Единственное, чем может повредить зомби-процесс - это забить всю таблицу процессов.  
Можно проверить так:  `cat /proc/sys/kernel/threads-max`  

5. >В iovisor BCC есть утилита `opensnoop`:
   `root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop  
   /usr/sbin/opensnoop-bpfcc`  
   На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные сведения по установке.  
     
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5_OS1.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/5.1_OS1.JPG)  

6. >Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.  
  
   write - записывает инфу в файловый дескриптор 1, ну а сама команда `uname -a` согласно ключу -a выводит всю системную информацию о ядре, кроме проца и харда.;
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6_OS1.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/6.2_OS1.JPG)  
  
7. >Чем отличается последовательность команд через ; и через && в bash? Например:  
   `root@netology1:~# test -d /tmp/some_dir; echo Hi  
   Hi  
   root@netology1:~# test -d /tmp/some_dir && echo Hi  
   root@netology1:~#`  
   Есть ли смысл использовать в bash `&&`, если применить `set -e`?  

*Оператор `;` необходим для выполнения последовательно команд одну за другой, результат 1й команды никак не зависит от 2ой.  
*Оператор `&&` все тоже самое, только выполняется условие, если после выполнения 1й команды вернется true, то продолжить, иначе прервать.  

   В man bash написано:  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/7_OS1.JPG)
  
   Параметр `set -e` указывает bash немедленно выйти, если какая-либо команда имеет ненулевой статус выхода.
   Благодаря set'у мы намеренно вызываем сбой выполнения скрипта/команды, чтобы избежать этих ошибок в дальнейшей эксплуатации.  
  
Смысл конечно же есть, т.к. `set` имеет расширенный функционал, нежели оператор `&&`.  
Но если составить набор простых команд через `&&` и `set -e`; то получим одинаковый результат.  
`vagrant@ubuntu-devops5:~$ (false && echo "ненулевой" ) && [ $? -eq 0 ] || echo "нулевой"`  
`нулевой`  
`vagrant@ubuntu-devops5:~$ (set -e; false && echo "ненулевой" ) && [ $? -eq 0 ] || echo "нулевой"`  
`нулевой`  
Но как только мы начнем усложнять конструкции, будем  
прописывать условия в подоболочке оболочки, использовать исключения, дебажить, а еще и в придачу различные ключи set'a, то конечно чистым оператором &&
не обойтись.  
 
 


8. >Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?  
  
**выдержки из man bash по set'y:**  
  
*-e      Exit immediately if a pipeline (which may consist of a single simple command), a list, or a compound command (see SHELL GRAMMAR above), exits
with a non-zero status.  The shell does not exit if the command that fails is part of the command list immediately following a while or until
keyword, part of the test following the if or elif reserved words, part of any command executed in a && or || list except the command follow‐
ing the final && or ||, any command in a pipeline but the last, or if the command's return value is being inverted with  !.   If  a  compound
command other than a subshell returns a non-zero status because a command failed while -e was being ignored, the shell does not exit.  A trap
on ERR, if set, is executed before the shell exits.  This option applies to the shell environment and each  subshell  environment  separately
(see COMMAND EXECUTION ENVIRONMENT above), and may cause subshells to exit before executing all the commands in the subshell.*  
  
 If  a  compound  command or shell function executes in a context where -e is being ignored, none of the commands executed within the compound
command or function body will be affected by the -e setting, even if -e is set and a command returns a failure status.  If a compound command
or  shell function sets -e while executing in a context where -e is ignored, that setting will not have any effect until the compound command 
  or the command containing the function call completes.

**указываем bash немедленно выйти, если какая-либо команда имеет ненулевой статус выхода. Подробнее написал в 7 задании.**
  
*-u      Treat  unset  variables and parameters other than the special parameters "`@`" and "`*`" as an error when performing parameter expansion.  If ex‐
pansion is attempted on an unset variable or parameter, the shell prints an error message, and, if not interactive,  exits  with  a  non-zero*
status*  
  
**Проверяем установлены ли ссылки на любые переменные, которые ранее не объявили, кроме "@" and "`*`".**  
  
*-x      After expanding each simple command, for command, case command, select command, or arithmetic for command, display the expanded value of PS4,
followed by the command and its expanded arguments or associated word list.*
  
**Будет выводить на экран этапы выполнения команд. Видимо удобно при траблшутинге.**  
  
*-o option-name  тут и выбираем опцию pipefail  
If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or  zero  if  all
commands in the pipeline exit successfully.  This option is disabled by default.*  
  
**Этот параметр предотвращает маскировку ошибок в конвейере. Если какая-либо команда в конвейере фейлится, то код ошибки будет использоваться как код ошибки всего конвейера.
По умолчанию код возврата конвейера - это код последней команды, даже если она выполнена успешно.**  
  
**Итог: отловили ошибки, проверили необъявленные переменные, вывели все этапы выполнения команды, не забыли про конвейер, что он тоже может шалить.**  
  
9. >Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).  
  
Понимаю, что список будет не статичный, но на момент выполнения у меня так:  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/9_OS1.JPG)  
Ss  Спят, пока не закончится выполнение процесса. s - я так понимаю типо родитель, верхнеуровневая сессия.  
T   Остановленные процессы  
R+  запущенные топчики  

