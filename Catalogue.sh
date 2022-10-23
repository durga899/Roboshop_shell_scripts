LOG_FILE=/tmp/mongodb

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo Please execute script in Root user or with Sudo Priviliges
  exit 1
fi

source common.sh

Nodejs