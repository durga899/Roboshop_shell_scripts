LOG_FILE=/tmp/mysql
source common.sh

echo Getting Mysql rep
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
StatusCheck $?

echo Disable Mysql Default  module to enable 5.7 mysql
dnf module disable mysql -y &>>$LOG_FILE
StatusCheck $?

echo Install Mysql
yum install mysql-community-server -y  &>>$LOG_FILE
StatusCheck $?

echo Start Mysql service
systemctl enable mysqld  &>>$LOG_FILE
systemctl restart mysqld  &>>$LOG_FILE
StatusCheck $?

echo Getting default password
def_paswd=$(grep 'A temporary password'  /var/log/mysqld.log | awk '{print $NF}')
StatusCheck $?

echo "Sending password changing commands to a file (export mentioned varaible with value in system)"
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${Robo_mysql_paswd}');
     FLUSH PRIVILEGES;" > /tmp/sql_passwd_cmnds
StatusCheck $?

echo "show databases;" | mysql -uroot -p'${Robo_mysql_paswd}'
if [ $? -ne 0 ]; then
  echo Changing the default mysql root paswd
  mysql --connect-expired-password -uroot -p"${def_paswd}" </tmp/sql_passwd_cmnds &>>$LOG_FILE
  StatusCheck $?
fi
