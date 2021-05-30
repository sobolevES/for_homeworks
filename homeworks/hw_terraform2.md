1. >Задача 1. Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).  
Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов.  
AWS предоставляет достаточно много бесплатных ресурсов в первых год после регистрации, подробно описано здесь.
1)Создайте аккаут aws.  
2)Установите c aws-cli https://aws.amazon.com/cli/.  
3)Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.  
4)Создайте IAM политику для терраформа c правами  
    -AmazonEC2FullAccess  
	-AmazonS3FullAccess  
	-AmazonDynamoDBFullAccess  
	-AmazonRDSFullAccess  
	-CloudWatchFullAccess  
	-IAMFullAccess
5)Добавьте переменные окружения  
`export AWS_ACCESS_KEY_ID=(your access key id)`  
`export AWS_SECRET_ACCESS_KEY=(your secret access key)`
6)Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс.  
В виде результата задания приложите вывод команды `aws configure list`.  


![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.1_terraform2.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.2_terraform2.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.3_terraform2.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.4_terraform2.JPG)  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.5_terraform2.JPG)  
  
Ну и судя по доке Terraform'а запись еще какое то время будет видно, но через какое то время автоматически сам удалится.  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.6_terraform2.JPG)  
  
под виндой тоже попробовал ради интереса  
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/1.7_terraform2.JPG)  
  
2. >Задача 2. Созданием ec2 через терраформ.  
1)В каталоге terraform вашего основного репозитория, который был создан в начале курсе, создайте файл main.tf и versions.tf.  
2)Зарегистрируйте провайдер для aws. В файл main.tf добавьте блок provider, а в versions.tf блок terraform с вложенным блоком required_providers. Укажите любой выбранный вами регион внутри блока provider.  
3)Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунта. Поэтому в предыдущем задании мы указывали их в виде переменных окружения.  
4)В файле main.tf воспользуйтесь блоком data "aws_ami для поиска ami образа последнего Ubuntu.  
5)В файле main.tf создайте рессурс ec2 instance. Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке Example Usage, но желательно, указать большее количество параметров.  
6)Добавьте data-блоки aws_caller_identity и aws_region.  
7)В файл outputs.tf поместить блоки output с данными об используемых в данный момент:  
	-AWS account ID,  
	-AWS user ID,  
	-AWS регион, который используется в данный момент,  
	-Приватный IP ec2 инстансы,  
	-Идентификатор подсети в которой создан инстанс.  
8)Если вы выполнили первый пункт, то добейтесь того, что бы команда terraform plan выполнялась без ошибок.  
В качестве результата задания предоставьте:  
	1)Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?  
	2)Ссылку на репозиторий с исходной конфигурацией терраформа.  



Создать AMI можно при помощи Packer, Ansible
  
![Screenshot](https://gitlab.com/SobolevES/devops-netology/-/raw/main/pics/2.1_terraform2.JPG)  
  
https://gitlab.com/SobolevES/devops-netology/-/tree/main/terraform
