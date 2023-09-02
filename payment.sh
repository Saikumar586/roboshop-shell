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

yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "install python"

useradd roboshop   &>>$LOGFILE

mkdir /app &>>$LOGFILE


curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "zip file payment"

cd /app  &>>$LOGFILE

VALIDATE $? "change directory"

unzip /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "unzip file"

cd /app  &>>$LOGFILE

VALIDATE $? "change directory"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "install pip"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

VALIDATE $? "copy service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable payment     &>>$LOGFILE

VALIDATE $? "enable payment"

systemctl start payment &>>$LOGFILE

VALIDATE $? "start payment"


