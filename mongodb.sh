#!/bin/bash

USERID=$(id -u)
R="\e[31m" #'\e[0;32m'
G="\e[32m"
N="\e[0m"
FILENAME=$0
DATE=$(date +%F)
LOGFILE=/tmp/$DATE-$FILENAME

if [ USERID -ne 0 ];
then 
    echo -e " Error : $R pls run with root user $N"
    exit
fi

VALIDATE()
{
    if [ $1 -ne 0 ]
then 
    echo -e "$R failure $N "
    exit 1
else
    echo -e "$G success $N "
fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "copy the mongo db repo into yum repos d" 

yum install mongodb-org -y &>>$LOGFILE
VALIDATE $? "Mongo db installed" 

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "Enable mongo db" 

systemctl start mongod &>>$LOGFILE
VALIDATE $? "start mongo db" 

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "replace the old ip to new ip" 

systemctl restart mongod &>>$LOGFILE
VALIDATE $? "restart mongodb" 
 
