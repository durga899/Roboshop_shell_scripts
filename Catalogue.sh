LOG_FILE=/tmp/mongodb

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo Please execute script in Root user or with Sudo Priviliges
  exit 1
fi
echo setup nodejs
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = success
else
  echo status = failure
  exit 1
fi

echo Install nodejs
yum install nodejs -y &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = success
else
  echo status = failure
  exit 1
fi

echo Adding roboshop user
id roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo User already exists
else
  useradd roboshop &>>LOG_FILE
  if [ $? -eq 0 ]; then
    echo Status = success
  else
    echo status = failure
    exit 1
  fi
fi





echo Downloading catalogue application code
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = success
else
  echo status = failure
  exit 1
fi

cd /home/roboshop
echo Extract catalogue
unzip /tmp/catalogue.zip &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = success
else
  echo status = failure
  exit 1
fi

echo Moving catalogue-main to catalogue
mv catalogue-main catalogue
if [ $? -eq 0 ]; then
  echo Status = success
else
  echo status = failure
  exit 1
fi
cd /home/roboshop/catalogue

npm install &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo Status = success
else
  echo status = failure
  exit 1
fi

echo Setup Catalogue service
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
if [ $? -eq 0 ]; then
  echo Status = success
else
  echo status = failure
  exit 1
fi

systemctl daemon-reload  &>>LOG_FILE
systemctl start catalogue
systemctl enable catalogue

