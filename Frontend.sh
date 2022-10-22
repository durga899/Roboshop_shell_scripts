 LOG_FILE=/tmp/frontend

 ID=$(id -u)
 if [ $ID -ne 0 ]; then
   echo Please execute script in Root user or with Sudo Priviliges
   exit 1
 fi

StatusCheck(){
  if [ $1 -eq 0 ]; then
    echo -e Status = "\e[32msuccess\e[0m"
  else
    echo -e status = "\e31mfailure\e[0m"
    exit 1
  fi
}


 echo Installing Nginx
 yum install nginx -y &>>LOG_FILE
 StatusCheck $?

 systemctl enable nginx
 systemctl start nginx
 echo Downloading web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>LOG_FILE
 StatusCheck $?

 cd /usr/share/nginx/html

 echo Removing old content
 rm -rf *
 StatusCheck $?

 echo Unzipping frontend file
 unzip /tmp/frontend.zip &>>LOG_FILE
 StatusCheck $?

 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>LOG_FILE

 echo Restarting Nginx
 systemctl restart nginx
 StatusCheck $?