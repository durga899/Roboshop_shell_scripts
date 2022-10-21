LOG_FILE=/tmp/mongodb
echo Getting Mongodb repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>LOG_FILE
echo status = $?

echo Installing mongodb
yum install -y mongodb-org &>>LOG_FILE
echo status = $?

echo Starting mongodb
systemctl enable mongod
systemctl start mongod

echo Editing mongo file
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf
echo status = $?

echo Downloading mongodb schema
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>LOG_FILE
echo status = $?

cd /tmp
unzip mongodb.zip &>>LOG_FILE
cd mongodb-main
mongo < catalogue.js
mongo < users.js

