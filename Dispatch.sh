COMPONENT=dispatch
LOG_FILE=/tmp/${COMPONENT}

source common.sh

echo Installing Go-lang
yum install golang -y &>>${LOG_FILE}
StatusCheck $?

AddRoboshopUser
