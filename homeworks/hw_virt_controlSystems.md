1. >Выберете подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.
  
#>>>100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий  
Много рабочих станций, значит должен быть мощный инструмент виртуализации. Тут я остановлю свой выбор на VMware vSphere. У данной системы огромный функционал, если мы купим лицензию :)) можно будет делать и резервные копии и ядер накидывать более чем 8 и различные миграционные операции, внутренний мониторинг системы и т.д.  
  
#>>>Требуется наиболее производительное бесплатное opensource решение для виртуализации небольшой (20 серверов) инфраструктуры Linux и Windows виртуальных машин  
Cудя по тому, что я прочитал самое оптимальное бесплатное решение будет - это KVM. Основнымы преимуществами данной системы виртуализации является полноценное выделение ресурсов для виртуальной машины, что гарантирует большую стабильность работы, поддержку всех гостевых ОС и бесплатную лицензию.  
  
#>>>Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры  
Самым логичным наверное будет использовать продукт от компании Microsoft - это гипервизор Hyper-V. Винда должна работать с виндой) + простой в настройке и эксплуатации и поддерживает все виды OS Win.  
  
#>>>Необходимо рабочее окружение для тестирование программного продукта на нескольких дистрибутивах Linux  
Думаю тут без разницы что будет использовано, тот же оракловый VirtualBox или VMware Workstation может сгодится. Даже если убьем виртуалку - не беда.  
  
2. >Опишите сценарий миграции с VMware vSphere на Hyper-V для Linux и Windows виртуальных машин. Детально опишите необходимые шаги для использования всех преимуществ Hyper-V для Windows.
 
 -установил VMWare  
 -развернул ВМ  
 -выделил им ресурсы, у меня создались файлы *.vmdk  
 -установил StarWind V2V Converter  
 -включил компоненты hyper-v  
 -экспортировал виртуалку  
 -сконвертировал прогой StarWind  
 -закинул сконвертированный диск к вольюмам хайпер-ви  
 -зашел в hyper-v а там уже моя виртуалка создана...  
 -прошелся по настройкам, сверил, чтобы были аналогичные с вмвари  
 -в настройках подвязал наш сконвертированный виртуальный диск  
 -старт:  
   -1.винда без проблем стартовала  
   -2.убунту без проблем стартовала  
   -3.а вот центос крашился при загрузке, помогло восстановление  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_virt.JPG)  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.2_virt.JPG)  
  
Microsoft Hyper-V - это нативный гипервизор, в отличие от VMWare, он работает непосредственно на оборудовании.  
  
  -Первое - это наверное в биосе включить возможность работать с VM  
  -Модуль Hyper-V для Windows PowerShell  #куча командлетов для работы с VM, включается все там же в компонентах винды  
  -Использование виртуального коммутатора NAT на сервере Hyper-V #вот урл для настройки: https://www.thomasmaurer.ch/2016/05/set-up-a-hyper-v-virtual-switch-using-a-nat-network/  
  -расширенный режим сеанса для обмена локальной РС и ВМ (Enhanced Session Mode)  #включается в настройках hyper-v  
  -установка VM не только с исошника, а штатно используя Hyper-V Quick Create VM Gallery - Быстрое создание ВМ  #функция есть на борту хайпер-ви  
  -создание нескольких типов контрольных точек отката. Читая статьи впервые узнал, что еще бывают продакшн точка отката) Выбор типа можно определить в настройках диспетчера Hyper-V ну или PowerShell'ом.  
  -еще про "Песочницу Windows" вычитал, что так же использует технологию hyper-V. Песочница позволяет раскрутить изолированную временную среду рабочего стола, где вы можете запускать ненадежное программное обеспечение. В теории все понятно, как эт овсе на практике... покажет только практика)   https://www.thomasmaurer.ch/2019/05/how-to-configure-windows-sandbox/  
  -Hyper-V Battery Pass-through.  вроде "безделушка", но может быть и полезна. https://www.thomasmaurer.ch/2017/07/hyper-v-gets-virtual-battery-support/  
  -nested-виртуализация внутри Hyper-V. Вложенная виртуализация. Тоже гайд по настройке есть https://www.thomasmaurer.ch/2017/07/how-to-setup-nested-virtualization-in-microsoft-azure/  
  -контейнеризация оказывается тоже использует технологию Hyper-V. но я так полагаю достаточно включенного компонента.  

3. >Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был бы выбор, то создавали ли вы бы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.
  
Каждая среда виртуализации имеет свои требования.  
Возможно потребуется разные типы ОС для поднятия гипервизора, а это разная архитектура, что для компаний не особо удобно.  
Если архитектура разная, значит нужна для каждой своя команда администрирования и поддержки, лицензия, - все это выходит в круглую сумму.  
Программной части более одной, значит больше шансов, что система может сбойнуть, так же нет единой точки отказа.  
  
Теперь про мой выбор и мой опыт работы с системами управления виртуальными машинами.   
В организации, в которой я тружусь парк техники ого-го какой, и каждые n-лет мы с кем нибудь объединяемся,   
а слияния всегда сопровождаются программным слиянием. Не бывает такого, что все тачки остаются в одном домене или системы, которые дублируют друг друга жили, как мирные соседи, всегда остается что то одно (включая дублирующие отделы).  
Тоже самое и с гипервизором, у нас одна лицензия вмвари, одно сопровождение, одна система мониторинга. Выгодно, удобно, практично. За все время я помню только один сбой и то его устранили в течение 10 минут.  
Я за единый тип гипервизора.  
