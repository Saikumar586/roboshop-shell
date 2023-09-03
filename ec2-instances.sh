#!/bin/bash


NAMES=( "Mongodb" "catalogue" "redis" "mysql" "rabbitmq" "user" "payment" "dispatch" "web" )

for i in "${NAMES[@]}"
do 
echo "create instances: $i"
done

