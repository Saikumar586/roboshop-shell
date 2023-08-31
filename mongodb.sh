#!/bin/bash

USERID=$(id -u)
R="\e[31m" #'\e[0;32m'
G="\e[33m"
N="\e[0m"
FILENAME=$0
DATE=$(date +%F)
LOGFILE=/tmp/$DATE-$FILENAME

if [ $USERID -ne 0 ];
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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "copy the mongo db repo into yum repos d" 

yum install mongodb-org -y &>>$LOGFILE
VALIDATE $? "Mongo db installed $G" 

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "Enable mongo db $G" 

systemctl start mongod &>>$LOGFILE
VALIDATE $? "start mongo db $G" 

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "replace the old ip to new ip $G" 

systemctl restart mongod &>>$LOGFILE
VALIDATE $? "restart mongodb $G" 
 
