COMPONENT=rabbitmq
LOG_FILE=/tmp/rabbitmq

source common.sh

echo Getting Erlang repo
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
StatusCheck $?

echo Installing Erlang
yum install erlang -y
StatusCheck $?

echo Setting YUM repositories for RabbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
StatusCheck $?

echo Installing RabbitMQ
yum install rabbitmq-server -y
StatusCheck $?

echo Starting RabbitMQ
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
StatusCheck $?

echo Adding application user in RabbitMQ
rabbitmqctl add_user roboshop roboshop123
StatusCheck $?

echo Adding application user tags in RabbitMQ
rabbitmqctl set_user_tags roboshop administrator
StatusCheck $?

echo Add Permissions for user in RabbitMQ
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
StatusCheck $?