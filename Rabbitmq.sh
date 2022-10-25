LOG_FILE=/tmp/rabbitmq

source common.sh

echo Getting Erlang repo
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${LOG_FILE}
StatusCheck $?

echo Installing Erlang
yum install erlang -y &>>${LOG_FILE}
StatusCheck $?

echo Setting YUM repositories for RabbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>${LOG_FILE}
StatusCheck $?

echo Installing RabbitMQ
yum install rabbitmq-server -y &>>${LOG_FILE}
StatusCheck $?

echo Starting RabbitMQ
systemctl enable rabbitmq-server &>>${LOG_FILE}
systemctl start rabbitmq-server &>>${LOG_FILE}
StatusCheck $?

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
   echo Adding application user in RabbitMQ
   rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
   StatusCheck $?
fi

echo Adding application user tags in RabbitMQ
rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE}
StatusCheck $?

echo Add Permissions for user in RabbitMQ
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG_FILE}
StatusCheck $?