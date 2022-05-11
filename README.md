# Занятие 7. Подготовка образов с помощью Packer
### ДЗ
всё сделанное  находится в папке packer

создать образ
`packer validate -var-file="variables.json"  ./ubuntu16.json`

создать VM `./yc_metadata_from_file.sh`

проверял по
ip_for_packer_homework=51.250.65.124
port_for_packer_homework = 9292

# Занятие 6. Основные сервисы Yandex Cloud
### Дополнительное задача ДЗ №4

Скрипт yc_metadata_from_file.sh

данные для проверки
testapp_IP = 51.250.65.124
testapp_port = 9292

# Занятие 5. Знакомство с облачной инфраструктурой и облачными сервисами
### Доплонительная задача ДЗ №3

Предложить вариант решения для подключения из консоли при помощи
команды вида `ssh someinternalhost` из локальной консоли рабочего устройства,
чтобы подключение выполнялось по алиасу `someinternalhost`

подключение в одну стркоу

`ssh  -o StrictHostKeyChecking=no -t -i ~/.ssh/appuser -A appuser@51.250.71.92 ssh  -o StrictHostKeyChecking=no appuser@10.128.0.20`


### вариант alias №1
добавляем в зависимости от оболочки  в  `~/.zshrc` или `~/.bash_aliases`

`alias sshSome='ssh  -o StrictHostKeyChecking=no -t -i ~/.ssh/appuser -A appuser@51.250.71.92 ssh  -o StrictHostKeyChecking=no appuser@10.128.0.20'`
`alias sshSomeVPN='ssh  -o StrictHostKeyChecking=no -t -i ~/.ssh/appuser -A appuser@192.168.186.1 ssh  -o StrictHostKeyChecking=no appuser@10.128.0.20'`

вход `sshSome`

### вариант alias №2
#### файл конфигурации SSH сервера `/etc/ssh/sshd_config`

Возможные настрйоки

`SyslogFacility AUTH`
`LogLevel INFO` - уровень логирования

Опция `LoginGraceTime` определяет количество секунд, в течение которых следует сохранять подключение при отсутствии успешных попыток входа в систему.
Возможно, вам может быть полезным задать для этого параметра чуть большее количество времени, чем то, которое вам обычно требуется для входа.

`PermitRootLogin` определяет, разрешен ли вход с помощью пользователя с правами root.
В большинстве случаев необходимо изменить значение на no, если вы создали учетную запись пользователя, которая имеет доступ к высокому уровню привилегий (через su или sudo) и может использоваться для входа в систему через ssh.

`strictModes` — это защитник, который будет препятствовать попыткам входа, если файлы аутентификации доступны для чтения всем.

`PasswordAuthentication no` - отключить вход по паролю
`PubkeyAuthentication yes` - разрешен только вход на основе открытого ключа

`ChallengeResponseAuthentication no` - не совсем понятно, но вроде отключает пароли типа challenge-response

### файл SSH клиента `nano ~/.ssh/config`

```
Host bastion
    HostName 51.250.71.92
    IdentityFile ~/.ssh/appuser
    User appuser
    StrictHostKeyChecking no
Host someinternalhost
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/appuser
    User appuser
    LogLevel INFO
    ForwardAgent yes
    ForwardX11 yes
    ProxyCommand ssh -q bastion -o StrictHostKeyChecking=no nc 10.128.0.20 22
```
`Host` - список шаблонов для хоста (его alias можно сказать)

`HostName 51.250.71.92` - Указывает реальное имя хоста для входа. Это можно использовать для указания псевдонимов или сокращений для хостов. По умолчанию используется имя, указанное в командной строке. Также разрешены числовые IP-адреса (как в командной строке, так и в спецификациях HostName).

`IdentityFile ~/.ssh/appuser` - Указывает файл, из которого считывается ключ идентификации пользователя при использовании проверки подлинности с открытым ключом

`User appuser` -  предпологаю это пользователь под которым мы входим на удаленный сервер

`ForwardAgent yes` - включить SSH Agent Forwarding

`Port` - SSH порт для подключения

`ProxyCommand ssh -q bastion -o StrictHostKeyChecking=no nc 10.128.0.20 22`-
используеться в качестве канала к целевой машине.
При использовании SSH на первой машине и прямой настройке простого «netcat» (nc) на цель оттуда,
это в основном просто пересылка открытого текста на внутреннюю машину от брокера между ними.
Параметры -q предназначены для отключения любого вывода.

# изменения порядка устаовки для VPN для Ubuntu 20.04

```
sudo apt-get update
sudo apt-get -y upgrade
echo "deb http://repo.pritunl.com/stable/apt focal main" | sudo tee /etc/apt/sources.list.d/pritunl.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt update
sudo apt-get install -y mongodb-org
sudo apt install pritunl
sudo systemctl enable mongod pritunl
sudo systemctl start mongod pritunl
```

[статья для установки клиента и сервера VPN](https://computingforgeeks.com/install-and-configure-pritunl-vpn-server-on-ubuntu/)

установка: `udo apt-get install network-manager  network-manager-openvpn`

для Gnome: `sudo apt-get install network-manager-gnome network-manager-openvpn-gnome`

импорт ```sudo nmcli connection import type openvpn file Users_test_server.ovpn
Соединение «Users_test_server» (a07524f8-09a0-4626-8b36-9c8705624844) добавлено.```

запуск - `nmcli connection up Users_test_server.ovpn`

# Доплонительная задача ДЗ №3
реализуйте использование валидного сертификата для панели управления VPN-сервера

вроде DNS добавил но он пока работает только если ображатся к конкретному DNS серверу

[dns](https://cloud.yandex.ru/docs/dns/quickstart)
[lets encrypt](https://cloud.yandex.ru/docs/certificate-manager/operations/managed/cert-create)

далее запустил [проверку](https://cloud.yandex.ru/docs/certificate-manager/operations/managed/cert-validate)
[процедура похожу не быстрая](https://cloud.yandex.ru/docs/certificate-manager/concepts/challenges)

если потом DNS нормально будет работать то попробую с сервера

```
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo systemctl stop  pritunl
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

# данные для проверки
bastion_IP = 51.250.71.92
someinternalhost_IP = 10.128.0.20
