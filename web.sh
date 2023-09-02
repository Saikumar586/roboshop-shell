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

yum install nginx -y &>>$LOGFILE
VALIDATE $? "install ngnix"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enable ngnix"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "start ngnix"

#http://web.saidev.world:80

rm -rf /usr/share/nginx/html/*  &>>$LOGFILE
VALIDATE $? "remove html content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip  &>>$LOGFILE
VALIDATE $? "open zip file"

cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? "change the directory"

unzip /tmp/web.zip &>>$LOGFILE
VALIDATE $? " unzip the file"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE
VALIDATE $? "coping the services"

systemctl restart nginx   &>>$LOGFILE
VALIDATE $? " restart nginx file"


