 echo Installing Nginx
 yum install nginx -y
 systemctl enable nginx
 systemctl start nginx
 echo Downloading web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

 cd /usr/share/nginx/html

 echo Removing old content
 rm -rf *

 echo Unzipping frontend file
 unzip /tmp/frontend.zip

 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

 echo Restarting Nginx
 systemctl restart nginx