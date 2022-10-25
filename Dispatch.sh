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
