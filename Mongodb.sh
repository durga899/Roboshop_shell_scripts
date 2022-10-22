LOG_FILE=/tmp/mongodb

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo Please execute script in Root user or with Sudo Priviliges
  exit 1
fi

source common.sh

echo Getting Mongodb repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
StatusCheck $?

echo Installing mongodb
yum install -y mongodb-org &>>LOG_FILE
StatusCheck $?


echo Editing mongo file
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatusCheck $?

echo Starting mongodb
systemctl enable mongod &>>LOG_FILE
systemctl restart mongod &>>LOG_FILE
StatusCheck $?

echo Downloading mongodb schema
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"  &>>LOG_FILE
StatusCheck $?

cd /tmp
echo Unzipping mongodb
unzip -o mongodb.zip &>>LOG_FILE
StatusCheck $?

cd mongodb-main

echo Load Catalouge service
mongo < catalogue.js  &>>LOG_FILE
StatusCheck $?

echo Load User service schema
mongo < users.js  &>>LOG_FILE
StatusCheck $?



