#!/bin/bash

AMI_ID=ami-03265a0778a880afb
SG_ID=sg-074ce48c4ff2f7a70
INSTANCES=("mongodb" "mysql" "shipping" "cart" "catalogue" "user" "redis" "dispatch" "web" "rabbitmq" "payment")

for i in ${INSTANCES[@]}
do
    echo "instance is: $i"
    if [ $i="mongodb" ] || [ $i="mysql" ] || [ $i="shippinng" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-074ce48c4ff2f7a70 
done