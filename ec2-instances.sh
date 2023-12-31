#!/bin/bash

NAMES=("Mongodb" "catalogue" "redis" "mysql" "rabbitmq" "user" "cart" "payment" "shipping" "dispatch" "web")
INSTANCE_TYPE=""
DOMAIN_NAME=saidev.world
# if its mongodb or mysql then t3.medium other t2.micro
for i in "${NAMES[@]}"
do 

if [[ $i == "Mongodb" || $i == "mysql" ]]
then 
    INSTANCE_TYPE="t2.micro"
else 
    INSTANCE_TYPE="t2.micro"
fi
echo "create $i instance"
   CREATE_INSTANCE=$(aws ec2 run-instances --image-id ami-03265a0778a880afb  --instance-type t2.micro  --security-group-ids sg-028da1a64b2b90013 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
echo "create $i instance ip $CREATE_INSTANCE"

aws route53 change-resource-record-sets --hosted-zone-id Z06556232X8JRWK2P1ZOH --change-batch '
{
            "Comment": "CREATE A Record ",
            "Changes": [
        {
            "Action": "CREATE",
                        "ResourceRecordSet":
                         {  
                                    "Name": "'$i.$DOMAIN_NAME'",
                                    "Type": "A",
                                    "TTL": 1,       
                                 "ResourceRecords":[{ "Value": "'$CREATE_INSTANCE'"}]
                         }
        }
                        ]
}
'
done

