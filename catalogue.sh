#!/bin/bash

ID=$(id -u)

G="\e[32m"
R="\e[31m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo -e "Script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R Failed $N"
        exit 1
    else
        echo -e "$2...$G Success $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e " $R ERROR: Try with ROOT user $N"
    exit 1
else
    echo -e "$G SUCCESS: logged with root user $N"
fi


## NodeJS  version chnage

dnf module disable nodejs -y &>>LOGFILE
dnf module enable nodejs:18 -y &>>LOGFILE
VALIDATE $? "version change to 18"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "NodeJS Install"

useradd roboshop
VALIDATE $? "roboshop user create"

mkdir /app
VALIDATE $? "app directory create"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "app code download"

cd /app 
VALIDATE $? "into /app dir"

unzip /tmp/catalogue.zip
VALIDATE $? "unzip catalogue.zip"

cd /app
npm install 
VALIDATE $? "npm install"

cp catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "catalogue setup service copy "

systemctl daemon-reload
VALIDATE $? "demon reload"

systemctl enable catalogue
VALIDATE $? "enable catalogue"

systemctl start catalogue
VALIDATE $? "start catalogue"

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "mongodb repo copy"

dnf install mongodb-org-shell -y
VALIDATE $? "mongodb install"

mongo --host mongodb.devaws14.online </app/schema/catalogue.js












