1. >Вкратце опишите, как вы поняли - в чем основное отличие паравиртуализации и виртуализации на основе ОС.  

Наверное, основные отличия - это:  
- наличие гипервизора в паравиртуализации и отсутствии его в "виртуализации на основе ОС".  
- Если в паравиртуализации мы можем поднимать разные операционки, то в Виртуализации ОС поддерживается только одна.  
  
2. >Выберите тип один из вариантов использования организации физических серверов, в зависимости от условий использования.  
Опишите, почему вы выбрали к каждому целевому использованию такую организацию.
   
Была бы моя воля я бы все на виртуалки посадил :)  
Но откуда взяться виртуалке, если ресурсы дает нам железный физ сервер, поэтому без них никуда.  
  
Если исходить из моего опыта на тек месте работы, то должна быть такая схема: это как минимум 2 ЦОДа в разных сетях, определенное кол-во железных машин с отличным железом,  
объединенных в кластер, и на них развернуто ПО для виртуализации,
ну а далее развертка ОС под те или иные нужды. "Виртуализация уровня ОС" - у нас лично используется на 99% серваков.


**Высоконагруженная база данных, чувствительная к отказу**      >>> склоняюсь больше к паравиртуализации, т.к. в случае сбоя (например фатального) можно быстро вернуть бойца в строй, например склонировав стендбай и правкой некоторых параметров, типо алиаса. Хотя вариант с железными серверами я тоже не исключаю, вариант вполне себе отличный, но более финансово затратный )  
  
**Различные Java-приложения**                                   >>> виртуализация уровня ОС.    Поднимем виртуалку, там развернем докер, внутри каждого контейнера поставим джаву ну и развернем приложение. И удобно и практично.  
  
**Windows системы для использования Бухгалтерским отделом**     >>> паравиртуализация.  Поднимем виртуалочку, развернем там приложение, что то пустим мимо гипервизора, какую нибудь шару - это же бухгалтера, куча сканов, пусть напрямую кидают :)  
  
**Системы, выполняющие высокопроизводительные расчеты на GPU**  >>> физические сервера. Ресурсы не плавающие, а статичные. Что для такой задачи будет в самый раз.  


3. >Как вы думаете, возможно ли совмещать несколько типов виртуализации на одном сервере? Приведите пример такого совмещения.

Да.  
Например, в VirtualBox подняли ВМ, а на виртуальной машине настроили виртуализацию уровня ОС, тот же докер сконфигурировали.  
Это прям классическая схема в нашей орг. Выделили тебе машинку, а ты уже сам на ней настраиваешь контейнеризацию.  