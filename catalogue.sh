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

VALIDATE $? " RPM NODESOURCE INSTALLED"

yum install nodejs  & >>$LOGFILE
VALIDATE $? " NodeJs INSTALLED"

# echo "Enter a user name: "
# read name

# if grep -w $name /etc/passwd > /dev/null
# then
#     echo "user $name is on this system."
# else
#     echo "user $name does not exist." 
# fi

# echo "Enter a group name: "
# read name


useradd $name & >>$LOGFILE
#VALIDATE $? " user added"


mkdir /app & >>$LOGFILE
#VALIDATE $? " make directory"


# echo -n "Enter the username: "
# # read text
# # useradd $text
# if [ $uid -eq 0 ] then 
#     echo user exist
# else 

 
# echo "Enter directory name"
# read dirname
# unzip /tmp/catalogue.zip
# if [ ! -d "$app" ]
# then
#     echo "File doesn't exist. Creating now"
#     mkdir ./$app
#     echo "File created"
# else
#     echo "File exists"
# fi

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip & >>$LOGFILE

VALIDATE $? "open the zip file"

cd /app/  & >>$LOGFILE
VALIDATE $? " change the directory"


unzip /tmp/catalogue.zip & >>$LOGFILE
VALIDATE $? " unzip the file"


cd /app & >>$LOGFILE
VALIDATE $? " change dir "


npm install  & >>$LOGFILE
VALIDATE $? " install NPM "


cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service & >>$LOGFILE
VALIDATE $? " copy the catalogue service "


systemctl daemon-reload & >>$LOGFILE
VALIDATE $? " reload  "


systemctl enable catalogue & >>$LOGFILE
VALIDATE $? " enable "


systemctl start catalogue & >>$LOGFILE
VALIDATE $? "start catalogue  "


cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo & >>$LOGFILE
VALIDATE $? "copy mongo repo  "


yum install mongodb-org-shell -y & >>$LOGFILE
VALIDATE $? "install mongo  "


mongo --host mongodb.saidev.world </app/schema/catalogue.js & >>$LOGFILE
VALIDATE $? " provide host name : "





