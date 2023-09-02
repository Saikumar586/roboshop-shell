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
curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE

VALIDATE $? "donwloading zip file"

cd /app  &>>$LOGFILE
VALIDATE $? "change directory"

unzip /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "unzip"

cd /app &>>$LOGFILE
VALIDATE $? "change dir app"

npm install  &>>$LOGFILE
VALIDATE $? "install npm"
 
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service  &>>$LOGFILE
VALIDATE $? "copied cart file"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon -reload"

systemctl enable cart &>>$LOGFILE
VALIDATE $? "enable cart"

systemctl start cart &>>$LOGFILE
VALIDATE $? "start cart"












