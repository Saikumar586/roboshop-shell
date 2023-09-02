#!/bin/bash

USERID=$(id -u)
R="\e[31m" #'\e[0;32m'
G="\e[33m"
N="\e[0m"
FILENAME=$0
DATE=$(date +%F)
LOGFILE=/tmp/$FILENAME-$DATE
#url=$($curl -sL https://rpm.nodesource.com/setup_lts.x | bash


if [ $USERID -ne 0 ]
then 
     echo -e "Error : $R pls run with root user $N"
     exit 1
 fi

VALIDATE()
{
    if [ $1 -ne 0 ];
then 
    echo -e "$2 ... $R failure $N"
    exit 1
else
    echo -e "$2 ... $G success $N" 
fi
}

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "rabbitmq file"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? "rpm file"


yum install rabbitmq-server -y  &>>$LOGFILE
VALIDATE $? "rabbitmq file"


systemctl enable rabbitmq-server &>>$LOGFILE
VALIDATE $? "rabbitmq file"


systemctl start rabbitmq-server  &>>$LOGFILE
VALIDATE $? "rabbitmq file"


rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
VALIDATE $? "rabbitmq file"


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
VALIDATE $? "rabbitmq file"
