StatusCheck(){
  if [ $1 -eq 0 ]; then
    echo -e Status = "\e[32msuccess\e[0m"
  else
    echo -e status = "\e31mfailure\e[0m"
    exit 1
  fi
}

Rolecheck(){
  ID=$(id -u)
  if [ $ID -ne 0 ]; then
    echo Please execute script in Root user or with Sudo Priviliges
    exit 1
  fi
}


AddRoboshopUser(){

  echo Adding roboshop user
  id roboshop &>>${LOG_FILE}
  if [ $? -eq 0 ]; then
    echo User already exists
  else
    useradd roboshop &>>${LOG_FILE}
    StatusCheck $?
  fi

  echo Downloading ${component} application code
  curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip"  &>>${LOG_FILE}
  StatusCheck $?

  cd /home/roboshop
  echo Cleaning old content
  rm -rf ${component} &>>${LOG_FILE}
  StatusCheck $?

  echo Extract ${component}
  unzip /tmp/${component}.zip &>>${LOG_FILE}
  StatusCheck $?

  mv ${component}-main ${component}
  cd /home/roboshop/${component}
}

SystemD_Setup(){
    echo Updating systemD service file
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/'  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/'   -e 's/USERHOST/user.roboshop.internal/'  -e 's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${component}/systemd.service
    StatusCheck $?

    echo Setup ${component} service
    mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service  &>>${LOG_FILE}
    systemctl daemon-reload &>>${LOG_FILE}
    systemctl start ${component} &>>${LOG_FILE}
    systemctl enable ${component} &>>${LOG_FILE}
}


Nodejs(){
  echo setup Nodejs
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
  StatusCheck $?

  echo Install nodejs
  yum install nodejs -y &>>${LOG_FILE}
  StatusCheck $?

  AddRoboshopUser

  echo Installing npm
  npm install &>>${LOG_FILE}
  StatusCheck $?

  SystemD_Setup

}


Java(){
  echo Installing maven
  yum install maven -y &>>${LOG_FILE}
  StatusCheck $?

  AddRoboshopUser

  echo "Download dependencies & make package"
  mvn clean package &>>${LOG_FILE}
  StatusCheck $?
  mv target/${component}-1.0.jar ${component}.jar &>>${LOG_FILE}
  StatusCheck $?

  SystemD_Setup

}


Python(){
   echo Installing Python
   yum install python36 gcc python3-devel -y &>>${LOG_FILE}
   StatusCheck $?

   AddRoboshopUser

   echo Installing python dependencies
   pip3 install -r requirements.txt &>>${LOG_FILE}
   StatusCheck $?

   APP_UID=$(id -u roboshop)
   APP_GID=$(id -g roboshop)

   echo Changing uid and gid
   sed -i -e "/uid/ c uid = ${APP_UID}" -e "/gid/ c gid = ${APP_GID}" /home/roboshop/${component}/${component}.ini &>>${LOG_FILE}
   StatusCheck $?

   SystemD_Setup
}