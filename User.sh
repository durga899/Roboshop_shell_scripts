LOG_FILE=/tmp/redis

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo Please execute script in Root user or with Sudo Priviliges
  exit 1
fi

source common.sh

echo setup nodejs
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
StatusCheck $?

echo Install nodejs
yum install nodejs -y &>>LOG_FILE
StatusCheck $?

echo Adding roboshop user
id roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo User already exists
else
  useradd roboshop &>>LOG_FILE
  StatusCheck $?
fi

echo Downloading catalogue application code
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"  &>>LOG_FILE
StatusCheck $?

cd /home/roboshop
echo Cleaning old content
rm -rf user &>>LOG_FILE
StatusCheck $?

echo Extract user
unzip /tmp/user.zip &>>LOG_FILE

mv user-main user
cd /home/roboshop/user

echo Installing npm
npm install &>>LOG_FILE
StatusCheck $?

echo Updating systemD service file
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service
StatusCheck $?

echo Setup User service
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service  &>>LOG_FILE
systemctl daemon-reload &>>LOG_FILE
systemctl start user
systemctl enable user