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

yum module disable mysql -y  &>>$LOGFILE
VALIDATE $? "Disable my sql"

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE
VALIDATE $? "copy repo file"

yum install mysql-community-server -y &>>$LOGFILE
VALIDATE $? "install community server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enable mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "start mysql"


mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE
VALIDATE $? "set root password to mysql"

 
