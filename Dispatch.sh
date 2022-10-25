component=dispatch
LOG_FILE=/tmp/${component}

source common.sh

echo Installing Go-lang
yum install golang -y &>>${LOG_FILE}
StatusCheck $?

AddRoboshopUser

echo Dispatching
go mod init dispatch &>>${LOG_FILE}
StatusCheck $?

echo Getting
go get &>>${LOG_FILE}
StatusCheck $?

echo Build
go build &>>${LOG_FILE}
StatusCheck $?

echo Setup ${component} service
    mv /home/roboshop/${component}/systemd.service /etc/systemd/system/${component}.service  &>>${LOG_FILE}
    systemctl daemon-reload &>>${LOG_FILE}
    systemctl start ${component} &>>${LOG_FILE}
    systemctl enable ${component} &>>${LOG_FILE}
    StatusCheck $?