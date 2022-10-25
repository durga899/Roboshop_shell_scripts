LOG_FILE=/tmp/mysql
source common.sh

if [ -z "${Robo_mysql_paswd}" ]; then
  echo -e "\e[31m Declare Robo_mysql_paswd variable\e[0m "
  exit 1
fi

echo Getting Mysql rep
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
StatusCheck $?

echo Disable Mysql Default  module to enable 5.7 mysql
dnf module disable mysql -y &>>${LOG_FILE}
StatusCheck $?

echo Install Mysql
yum install mysql-community-server -y  &>>${LOG_FILE}
StatusCheck $?

echo Start Mysql service
systemctl enable mysqld  &>>${LOG_FILE}
systemctl restart mysqld  &>>${LOG_FILE}
StatusCheck $?

echo Getting default password
def_paswd=$(grep 'A temporary password'  /var/log/mysqld.log | awk '{print $NF}')
StatusCheck $?

echo "Sending password changing commands to a file (export mentioned varaible with value in system)"
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${Robo_mysql_paswd}');
     FLUSH PRIVILEGES;" > /tmp/sql_passwd_cmnds
StatusCheck $?

echo "show databases;" | mysql -uroot -p${Robo_mysql_paswd}  &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  echo Changing the default mysql root paswd
  mysql --connect-expired-password -uroot -p"${def_paswd}" </tmp/sql_passwd_cmnds &>>${LOG_FILE}
  StatusCheck $?
fi

echo "show plugins;" | mysql -uroot -p${Robo_mysql_paswd}  2>>/dev/null | grep validate_password  &>>${LOG_FILE}
if [ $? -eq 0 ]; then
   echo Uinstalling validate_password plugin
   echo "uninstall plugin validate_password;" | mysql -uroot -p${Robo_mysql_paswd} &>>${LOG_FILE}
   StatusCheck $?
fi

echo Download Schema
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /tmp
echo extracting mysql
unzip -o mysql.zip &>>${LOG_FILE}
StatusCheck $?

echo Load schema
cd mysql-main
mysql -u root -p${Robo_mysql_paswd} 2>>/dev/null <shipping.sql
StatusCheck $?
