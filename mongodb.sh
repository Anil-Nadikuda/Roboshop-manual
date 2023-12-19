#!/bin/bash

ID=$(id -u)

G="\e[31m"
R="\e[32m"
N="\e[0m"

VALIDATE(){
    if [$1 -ne 0]
    then
        echo -e "$R $2...Failed $N"
        exit 1
    else
        echo -e "$G $2...Success$N"
    fi
}

if [ID -ne 0]
then
    echo -e " $R ERROR: Try with ROOT user $N"
    exit 1
else
    echo -e "$G SUCCESS: logged with root user $N"
fi

yum install mysql -y

VALIDATE $? "mysql installed"