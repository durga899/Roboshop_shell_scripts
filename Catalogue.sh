LOG_FILE=/tmp/mongodb
echo setup nodejs
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
echo status = $?

echo Install nodejs
yum install nodejs -y &>>LOG_FILE
echo status = $?

echo Adding roboshop user
useradd roboshop &>>LOG_FILE

echo Downloading catalogue application code
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
echo status = $?

cd /home/roboshop
echo Extract catalogue
unzip /tmp/catalogue.zip &>>LOG_FILE
echo status = $?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo Installing npm
npm install &>>LOG_FILE
echo status = $?

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload  &>>LOG_FILE
systemctl start catalogue
systemctl enable catalogue

