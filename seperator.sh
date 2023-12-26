#!/bin/bash

file="/etc/passwd"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ ! -f $file ]
then
    echo -e "$R Source directory: $file doesnot exist $N"
fi

while IFS=":" read -r username password usr_id group_name user_fullname
do
    echo "username: $username"
    echo "usr_id: $usr_id"
    echo "user full name: $usr_fullname"

done <<< $file