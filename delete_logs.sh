#!/bin/bash
source_dir="/tmp/shellscript_logs"

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ ! -d $source_dir ]
then
    echo -e "$R Source directory: $source_dir doesnot exist $N"
fi

FILES_TO_DELETE=$(find $source_dir -type f -mtime +14 -name "*.log")

while IFS= read -r line
do
    echo "Deleting files: $line"
    rm -rf $line
done <<< $FILES_TO_DELETE
