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

for PACKAGE in $@
do 
    yum list installed $PACKAGE &>> $LOGFILE
    if [ $? -ne 0 ]
    then
    yum install $PACKAGE -y &>> $LOGFILE
    VALIDATE $? "Installation of $PACKAGE"
    else
    echo -e "$Y $PACKAGE already installed $N"
    fi
done

# yum install mysqql -y &>> $LOGFILE

# VALIDATE $? "mysql installed"

# yum install git -y &>> $LOGFILE
# VALIDATE $? "Installing GIT