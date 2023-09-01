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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "downloading node setup"

yum install nodejs -y  &>>$LOGFILE

VALIDATE $? "installing nodejs"

useradd roboshop &>>$LOGFILE
#VALIDATE $? "add user name roboshop"

mkdir /app &>>$LOGFILE

#VALIDATE $? "make dir name app"
curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

VALIDATE $? "donwloading zip file"

cd /app  &>>$LOGFILE
VALIDATE $? "change directory"

unzip /tmp/user.zip &>>$LOGFILE

VALIDATE $? "unzip"

cd /app &>>$LOGFILE
VALIDATE $? "change dir app"

npm install  &>>$LOGFILE
VALIDATE $? "install npm"
 
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service  &>>$LOGFILE
VALIDATE $? "copied user file"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon -reload"

systemctl enable user &>>$LOGFILE
VALIDATE $? "enable user"

systemctl start user &>>$LOGFILE
VALIDATE $? "start user"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOGFILE
VALIDATE $? "copy user repo"

yum install mongodb-org-shell -y &>>$LOGFILE
VALIDATE $? "install mongodb"


mongo --host mongodb.saidev.world </app/schema/user.js &>>$LOGFILE
VALIDATE $? " host name"











