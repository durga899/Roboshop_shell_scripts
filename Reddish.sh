LOG_FILE=/tmp/redis

source common.sh

Rolecheck

echo Getting Repos
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG_FILE}
StatusCheck $?

echo Enabling module
dnf module enable redis:remi-6.2 -y &>>${LOG_FILE}
StatusCheck $?

echo Installing redis
yum install redis -y &>>${LOG_FILE}
StatusCheck $?

echo Updating Redis listen addrs
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf  /etc/redis/redis.conf &>>${LOG_FILE}
StatusCheck $?

systemctl enable redis &>>${LOG_FILE}
echo Restarting redis
systemctl start redis &>>${LOG_FILE}
StatusCheck $?

