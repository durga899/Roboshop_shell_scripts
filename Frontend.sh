 echo Installing Nginx
 yum install ngiinx -y &>>/tmp/frontend
 if [ $? -eq 0 ]
 then
   echo Nginx installed successfully
 else
   echo Nginx installation failed
 fi

 systemctl enable nginx
 systemctl start nginx
 echo Downloading web content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend
 echo status = $?

 cd /usr/share/nginx/html

 echo Removing old content
 rm -rf *

 echo Unzipping frontend file
 unzip /tmp/frontend.zip &>>/tmp/frontend
 echo status = $?

 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/frontend

 echo Restarting Nginx
 echo status = $?
 systemctl restart nginx