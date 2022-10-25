component=dispatch
LOG_FILE=/tmp/${component}

source common.sh

echo Installing Go-lang
yum install golang -y &>>${LOG_FILE}
StatusCheck $?

AddRoboshopUser
