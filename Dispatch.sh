LOG_FILE=/tmp/dispatch

source common.sh

echo Installing Go-lang
yum install golang -y

AddRoboshopUser
