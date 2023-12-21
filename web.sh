#!/bin/bash

ID=$(id -u)

G="\e[32m"
R="\e[31m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
exec &?LOGFILE

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

dnf install nginx -y
VALIDATE $? "$Y nginx installation $N"

systemctl enable nginx
VALIDATE $? "$Y nginx Enable $N"

systemctl start nginx
VALIDATE $? "$Y nginx start $N"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "$Y removing nginx html content $N"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "$Y Download the frontend content $N"

cd /usr/share/nginx/html
VALIDATE $? " into html content folder "

unzip /tmp/web.zip
VALIDATE $? " unzipping frontend content "

cp /root/Roboshop-manual/roboshop.config /etc/nginx/default.d/roboshop.conf 
VALIDATE $? " Roboshop config file added"

systemctl restart nginx 
VALIDATE $? "nginx restart "


