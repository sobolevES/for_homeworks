5. 
>>Какие ресурсы выделены по-умолчанию?  

![screenshot1](https://gitlab.com/SobolevES/devops-netology/-/blob/main/pics/5.JPG)

6. 
>>как добавить оперативной памяти или ресурсов процессора виртуальной машине?

добавить в конфиг vargantfile:

config.vm.provider "virtualbox" do |v|  
  v.memory = 2048  
  v.cpus = 2  
end  



###### ~/.bash_history   #сюда пишем историю


8.1.
>>какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?

vagrant@ubuntu-devops5:~$ cat .bashrc | grep HIST
HISTCONTROL=ignoreboth
#######for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000  
HISTFILESIZE=2000  

![screenshot2](https://gitlab.com/SobolevES/devops-netology/-/blob/main/pics/HISTFILE&HISTFILESIZE.jpg)
![screenshot3](https://gitlab.com/SobolevES/devops-netology/-/blob/main/pics/HISTSIZE.jpg)

8.2.
>>что делает директива ignoreboth в bash?

 Сочетает в себе две опции:  
    ignorespace (строки/команды, которые начинаются с пробела не попадают в history) и  
    ignoredups (дублирующиеся подряд строки/команды не записываются в history)  
![screenshot4](https://gitlab.com/SobolevES/devops-netology/-/blob/main/pics/ignoreboth.jpg)


9. 
>>В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?  
    
156 строка. Упоминается про цикл  
224 строка. Состовные команды/Групповые. что типо того: vagrant@ubuntu-devops5:/opt/VBoxGuestAdditions-6.1.16$ { ls -l; echo ">>>>>>>>>"; date; echo ">>>>>>>>>"; ls; }  
524 строка. Из описания BASH_LINENO можно понять, что {} используются для объявления Массивов, Функций.  
533 строка. Описание BASH_SOURCE тоже массивы, функции  
548 строка. задается индекс курсора COMP_CWORD (пока не понял как применяется, но скобки также применимы)  
586 строка. FUNCNAME. Имя функции задается через ${фигурные скобки}  
896 строка. Brace Expansion. В {задаем шаблон, по которому будут генерится значения}  
950 строка. Parameter Expansion. Работа с параметрами ${parameter}  


10. 
>>Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов? А получилось ли создать 300000?

с 100000 все просто )  
    vagrant@ubuntu-devops5:~/test_dir$ touch test_{1..100000}  
    vagrant@ubuntu-devops5:~/test_dir$ ls | wc -l  
    100000  

а с 300000 уже все.  
    vagrant@ubuntu-devops5:~/test_dir$ touch test_{1..300000}  
    -bash: /usr/bin/touch: Argument list too long  


    vagrant@ubuntu-devops5:~/test_dir$ touch $(awk 'BEGIN { for(i=1;i<=300000;i++) printf "test_%d\n", i }')  
   -bash: /usr/bin/touch: Argument list too long  

Думаю через for do done можно реализовать 

11.
>>В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
   
Условное выражение, если tmp существует и является директорией, то true, иначе false  
   прочитал тут:  
man bash | grep "CONDITIONAL EXPRESSIONS"  
![screenshot5](https://gitlab.com/SobolevES/devops-netology/-/blob/main/pics/11.jpg)


12.
-Создал недостоющую директорию  
root@ubuntu-devops5:/tmp# mkdir new_path_directory  
root@ubuntu-devops5:/tmp/new_path_directory# env | grep PATH  
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin  

обнуляю переменную  
root@ubuntu-devops5:/tmp/new_path_directory# export PATH=  

меняю значение переменной PATH=/tmp/new_path_directory:/usr/local/bin:/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/usr/games:/usr/local/games:/snap/bin  

export PATH="${PATH}/tmp/new_path_directory:/usr/local/bin:/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/usr/games:/usr/local/games:/snap/bin"  

копируем исполняемый файл интерпритатора в нужные нам дириктории.  
root@ubuntu-devops5:/tmp# cp /bin/bash /tmp/new_path_directory/  
root@ubuntu-devops5:/tmp# cp /bin/bash /usr/local/bin/  


Итог:  
root@ubuntu-devops5:/tmp/new_path_directory# type -a bash  
bash is /tmp/new_path_directory/bash  
bash is /usr/local/bin/bash  
bash is /bin/bash  
bash is /usr/bin/bash  
![screenshot6](https://gitlab.com/SobolevES/devops-netology/-/blob/main/pics/12.jpg)  


13. 
>>Чем отличается планирование команд с помощью batch и at

Обе команды необходимы для планирования одноразовых задач, но  
  at             #в заданное время   
  batch (at -b)  #выполнение их когда позволит уровень загрузки системы (/proc/loadavg). Иначе будут весеть в очереди.  





