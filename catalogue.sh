USERID=$(id -u)
R="\e[31m" #'\e[0;32m'
G="\e[33m"
N="\e[0m"
FILENAME=$0
DATE=$(date +%F)
LOGFILE=/tmp/$DATE-$FILENAME
url=$(curl -sL https://rpm.nodesource.com/setup_lts.x | bash)

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

$url &<< $LOGFILE
VALIDATE $? " RPM NODESOURCE INSTALLED"

yum install nodejs 
VALIDATE $? " NodeJs INSTALLED"

echo -n "Enter the username: "
read text
useradd $text

echo "Enter directory name"
read dirname

if [ ! -d "$app" ]
then
    echo "File doesn't exist. Creating now"
    mkdir ./$app
    echo "File created"
else
    echo "File exists"
fi

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip > /app/catalogue.zip





