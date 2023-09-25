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
