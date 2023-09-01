#!/bin/bash

USERID=$(id -u)
R="\e[31m" #'\e[0;32m'
G="\e[33m"
N="\e[0m"
FILENAME=$0
DATE=$(date +%F)
LOGFILE=/tmp/$DATE-$FILENAME

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


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "rpms redies"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "enable redis"

yum install redis -y  &>>$LOGFILE

VALIDATE $? "install redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  /etc/redis/redis.conf  &>>$LOGFILE
VALIDATE $? "replace ip address"

systemctl enable redis &>>$LOGFILE
VALIDATE $? "install redis"

systemctl start redis &>>$LOGFILE
VALIDATE $? "install redis"





