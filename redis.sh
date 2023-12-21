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



dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "repo file as a rpm install"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "Enable Redis 6.2 from package streams."

dnf install redis -y
VALIDATE $? "Redis Install "


sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $LOGFILE
VALIDATE $? "Remote access to Redis"

systemctl enable redis
VALIDATE $? "Redis enable"


systemctl start redis &>> $LOGFILE
VALIDATE $? "start Redis"