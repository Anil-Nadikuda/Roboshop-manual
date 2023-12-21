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
VALIDATE $? "$Y version change to 18 $N"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "NodeJS Install"

useradd roboshop
if [ $? -ne 0 ]
    then
    echo -e "$Y roboshop already created $N"
    else
    echo -e "$G roboshop user create $N"
    fi

mkdir -p /app
if [ $? -ne 0 ]
    then
    echo -e "$Y app dir already created $N"
    else
    echo -e "$G app directory create $N"
    fi

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
VALIDATE $? "app code download"

cd /app 
VALIDATE $? "into /app dir"

unzip /tmp/user.zip
VALIDATE $? "unzip user.zip"

cd /app
npm install 
VALIDATE $? "npm install"

cp /root/Roboshop-manual/user.service /etc/systemd/system/user.service
VALIDATE $? "Setup SystemD user Service"

systemctl daemon-reload
VALIDATE $? "demon reload"

systemctl enable user
VALIDATE $? "enable user"

systemctl start user
VALIDATE $? "start user"

cp -f /root/Roboshop-manual/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Setup mongodb repo copy"

dnf install mongodb-org-shell -y
VALIDATE $? "mongodb install"

mongo --host mongodb.devaws14.online </app/schema/user.js











