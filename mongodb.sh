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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "mongo.repo file copy"

dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "Mongodb installation"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "MongoDB Enable"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "MongoDB start"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Remote access to Mongodb"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarting MongoDB"