# WELCOME TO THE CARD PLATFORM

This project is designed to work with the card platform. By generating pin codes, we can allow authorization and missed calls

### How to install
```bash
$ git clone https://github.com/motionrus/card-platform.git
$ cd card-platform
card-platform$ docker-compose up -d
Starting card-platform_asterisk15-lua_1 ... done
```


### Requirements
+ Docker
+ GIT

### What include docker file
+ Ubuntu 14.04
+ Asterisk 15.6.0
+ Lua 5.2
+ LuaRocks
+ mongodb driver & luamongo
+ g729

### Как это работает
Для начала мы должны создать абонента и указать что нужно использовать контекст скрипта `store/etc/asterisk/extension.lua`:
```bash
[74951089540](my-codecs)
type=friend
secret=74951089540
host=dynamic
context=cardplatform
```
Не плохо если у нас будет транк uplink куда мы будем звонить
```bash
[rtu](my-codecs)
type=peer
context=to_client
host=192.168.133.33
port=5061
insecure=port,invite
```

Настроим входящую связь с аплинка на абонента в extension.conf
```bash
[to_client]
exten => _[78]?4951089540,1,Dial(SIP/74951089540)
exten => 501000,1,Set(CALLERID(num)=74951089540)
exten => 501000,n,Dial(SIP/74951089540)
```

Логика работы написана в файле `store/etc/asterisk/extension.lua` . В переменной numbers можно генерировать произвольное количество логинов и паролей любой длины.

#### Описание работы скрипты
Мы можем авторизовывать клиентов с помощью двух переменных read_password и read_number_password, в зависимости от выбора в контексте `["_8X."] = [read_number_password|read_password];` можно определять логику работы. 
##### Переменная read_password выполняет:
авторизацию по 6 значному пин-коду. С привязкой пин-кода к номеру и выходом в аплинк. Реализация:
+ Абонент совершает исходящий МГ/МН вызов в контекст cardplatform
+ Автоинформатор просит ввести пароль
+ Функция `number` проверят если пароль существует в переменной numbers, то возвращает номер АОН
+ АОН подставляется в callerID и совершается вызов
+ Иначе проигравается ошибка

##### Переменная read_number_password выполняет:
Авторизацию по 6 значному номеру и 6 значному пин-коду. С выходом в аплинк. Реализация:
+ Автоинформатор просит ввести логин и пароль
+ Функция `check_login_password` проверяет если логин/пароль соответствуют, возвращает true
+ Логин подставляется в callerID и совершается вызов
+ Иначе проигрывается сообщение об ошибки