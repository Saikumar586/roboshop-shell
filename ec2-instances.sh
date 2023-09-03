#!/bin/bash


NAMES=( "Mongodb" "catalogue" "redis" "mysql" "rabbitmq" "user" "cart" "payment" "shipping" "dispatch" "web" )
INSTANCE_TYPE=""
# if its mongodb or mysql then t3.medium other t2.micro
for i in "${NAMES[@]}"
do 

if [[ $i == "Mongodb" || $i == "mysql" ]]
then 
    INSTANCE_TYPE="t3.medium"
else 
    INSTANCE_TYPE="t2.micro"
fi
echo "create $i instance"
   CREATE_INSTANCE=$(aws ec2 run-instances --image-id ami-03265a0778a880afb  --instance-type t2.micro  --security-group-ids 
    sg-0bf973e946668a277 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" || jq -r '.Instances[0].PrivateIpAddress')
echo "create $I instance ip $CREATE_INSTANCE"
done

