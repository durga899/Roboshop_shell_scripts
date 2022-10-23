StatusCheck(){
  if [ $1 -eq 0 ]; then
    echo -e Status = "\e[32msuccess\e[0m"
  else
    echo -e status = "\e31mfailure\e[0m"
    exit 1
  fi
}
Nodejs(){
  echo setup Nodejs
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

  echo Downloading ${component} application code
  curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"  &>>LOG_FILE
  StatusCheck $?

  cd /home/roboshop
  echo Cleaning old content
  rm -rf ${component} &>>LOG_FILE
  StatusCheck $?

  echo Extract ${component}
  unzip /tmp/${component}.zip &>>LOG_FILE

  mv ${component}-main ${component}
  cd /home/roboshop/user

  echo Installing npm
  npm install &>>LOG_FILE
  StatusCheck $?

  echo Updating systemD service file
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/'  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/${component}/systemd.service
  StatusCheck $?

  echo Setup ${component} service
  mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service  &>>LOG_FILE
  systemctl daemon-reload &>>LOG_FILE
  systemctl start ${component}
  systemctl enable ${component}
}