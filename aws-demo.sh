#!/bin/bash

ec2_mod () {

while : ; do

echo enter the region

read region

echo -e "0.u want to see all the instances then press 0\n1.do you want to see the stopped instances then press 1\n2.do you want to see the running instances then press 2\n3.do you want to start the insatnces then press 3\n4.do you want to stop the instances then press 4\n5.PRESS 5 TO EXIT"
read option

case $option in

    0)
    /usr/local/bin/aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name}' --output table --region $region

b=($(/usr/local/bin/aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name}' --output table --region $region))
[ -z "$b" ] && echo "no instances"
;;
    1)
/usr/local/bin/aws ec2 describe-instances \
    --filters Name=instance-state-name,Values=stopped \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output table --region $region
b=($(/usr/local/bin/aws ec2 describe-instances \
    --filters Name=instance-state-name,Values=stopped --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' --output table --region $region)) 
[ -z "$b" ] && echo "no stopped instances"

;;

    2)
/usr/local/bin/aws ec2 describe-instances \
    --filters Name=instance-state-name,Values=running \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output table --region $region
b=($(/usr/local/bin/aws ec2 describe-instances \
    --filters Name=instance-state-name,Values=running \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output table --region $region))
[ -z "$b" ] && echo "no instances running"

;;


   3)
read -r -p "Please enter the ids of instances to start the instances separated by spaces " -a ids

for id in "${ids[@]}"; do 

   /usr/local/bin/aws ec2 start-instances --instance-ids $id --region $region

           done
;;

   4)
read -r -p "Please enter the ids of instances to stop the instances separated by spaces " -a ids

for id in "${ids[@]}"; do

 /usr/local/bin/aws ec2 stop-instances --instance-ids $id --region $region

           done
;;

   5)
  echo exiting
  ;;

   *)
  echo -n "plz check the options that you have entered and try again"
  ;;

esac

if [ "$option" -eq 5 ]; then
    break
fi
done
}

rds_mod () {
while : ; do
echo enter the region

read region

echo -e "0.u want to list all rds instances then press 0\n1.do you want to see stopped rds instances then press 1\n2.do you want to see running rds instances then press 2\n3.do you want to run rds instances then press 3\n4.do you want to stop running instances then press 4\n5.if you want to go back then press 5"

read option

case $option in
   0)
/usr/local/bin/aws rds describe-db-instances --query 'DBInstances[*].{DBInstanceIdentifier:DBInstanceIdentifier,State:DBInstanceStatus}' --region us-east-2 --output table

b=($(/usr/local/bin/aws rds describe-db-instances --query 'DBInstances[*].{DBInstanceIdentifier:DBInstanceIdentifier,State:DBInstanceStatus}' --region us-east-2 --output table))
[ -z "$b" ] && echo "no rds instances in the selected region"
;;
   1)
    /usr/local/bin/aws rds describe-db-instances --output json --query "DBInstances[?contains(DBInstanceStatus, 'stopped')].[DBInstanceIdentifier]" --region us-east-2 --output table

b=($(/usr/local/bin/aws rds describe-db-instances --output json --query "DBInstances[?contains(DBInstanceStatus, 'stopped')].[DBInstanceIdentifier]" --region us-east-2 --output table))
[ -z "$b" ] && echo "no stopped rds instances"
;;
   2)
  /usr/local/bin/aws rds describe-db-instances --output json --query "DBInstances[?contains(DBInstanceStatus, 'available')].[DBInstanceIdentifier]" --region us-east-2 --output table

b=($(/usr/local/bin/aws rds describe-db-instances --output json --query "DBInstances[?contains(DBInstanceStatus, 'available')].[DBInstanceIdentifier]" --region us-east-2 --output table))
[ -z "$b" ] && echo "no running rds instances"
;;
   3)
read -r -p "Please enter the identifiers of rds instances to start the instances separated by spaces " -a ids

for id in "${ids[@]}"; do

   /usr/local/bin/aws rds start-db-instance --db-instance-identifier $id --region $region

           done
;;
   4)
read -r -p "Please enter the identifiers of rds instances to stop the instances separated by spaces " -a ids

for id in "${ids[@]}"; do

   /usr/local/bin/aws rds stop-db-instance --db-instance-identifier $id --region $region

           done
;;
   5)
  echo exiting
  ;;

   *)
  echo -n "plz check the options that you have entered and try again"
  ;;

esac
if [ "$option" -eq 5 ]; then
    break
fi
done
}

while : ; do

echo -e  "ec2 instances press 1\n"

echo -e  "rds instance press 2\n"

echo -e "exit press 3\n"

read -p "enter the value" one

if [ $one -eq 1 ]
then
 ec2_mod
elif [ $one -eq 2 ]
then
 rds_mod
elif [ $one -eq 3 ]
then
  break
fi
done
