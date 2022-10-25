LOG_FILE=/tmp/frontend

source common.sh

Rolecheck

 echo Installing Nginx
 yum install nginx -y &>>${LOG_FILE}
 StatusCheck $?

 systemctl enable nginx
 systemctl start nginx
 echo Downloading web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
 StatusCheck $?

 cd /usr/share/nginx/html

 echo Removing old content
 rm -rf *
 StatusCheck $?

 echo Unzipping frontend file
 unzip /tmp/frontend.zip &>>${LOG_FILE}
 StatusCheck $?

 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}

 echo Updating Roboshop config file
 sed i -e  '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/'   /etc/nginx/default.d/roboshop.conf  &>>${LOG_FILE}
  StatusCheck $?

 echo Restarting Nginx
 systemctl restart nginx
 StatusCheck $?