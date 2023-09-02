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
 
yum install maven -y &>>$LOGFILE
VALIDATE $? "INSTALL MAVEN"

useradd roboshop &>>$LOGFILE
mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE
VALIDATE $? "shipping zip file"

cd /app &>>$LOGFILE
VALIDATE $? "change directory"

unzip /tmp/shipping.zip &>>$LOGFILE
VALIDATE $? "unzip shipping doc :"

cd /app &>>$LOGFILE
VALIDATE $? "change directory"

mvn clean package  &>>$LOGFILE
VALIDATE $? "clean packages"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE
VALIDATE $? "move target"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE
VALIDATE $? "coping shipping service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "daemon reload"

systemctl enable shipping  &>>$LOGFILE
VALIDATE $? "enable shipping"

systemctl start shipping &>>$LOGFILE
VALIDATE $? "start shipping"

yum install mysql -y  &>>$LOGFILE
VALIDATE $? "install mysql"

mysql -h mysql.saidev.world -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>$LOGFILE
VALIDATE $? "provide mysql ip"

systemctl restart shipping &>>$LOGFILE
VALIDATE $? "restart shipping"



