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
if [ $? -ne 0 ]
    then
    echo "roboshop already created"
    else
    echo -e "$Y roboshop user create $N"
    fi

mkdir -p /app
if [ $? -ne 0 ]
    then
    echo "app dor already created"
    else
    echo -e "$Y app directory create $N"
    fi

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "app code download"

cd /app 
VALIDATE $? "into /app dir"

unzip /tmp/cart.zip
VALIDATE $? "unzip cart.zip"

cd /app

npm install 
VALIDATE $? "npm install"

cp /root/Roboshop-manual/cart.service /etc/systemd/system/cart.service
VALIDATE $? "cart setup service copy "

systemctl daemon-reload
VALIDATE $? "demon reload"

systemctl enable cart
VALIDATE $? "enable cart"

systemctl start cart
VALIDATE $? "start cart"

