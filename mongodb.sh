#!/bin/bash

DATE=$(date +%F)

R="\e[31m"
G="\e[32m"
N="\e[0m"

LOGSDIR=/home/centos/shell-script
SCRIPT_NAME=$0
LOGSFILE=$LOGSDIDR/$SCRIPT_NAME-$DATE.log

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 $R ... failure $N "
        exit 1
    else
        echo -e "$2 $G ...Success $N "
    fi
}

USERID=$(id -u)
if [$USERID -ne 0]
then
    echo -e $R ERROR: please proceed with Root user $N
    exit 1
else
    echo -e $G You are root user $N
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "Copies Mongo.repo to mongo.repos.d folder"

yum install mongodb-org -y &>>$LOGFILE
VALIDATE $? "Installed Mongodb-org" 

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "Enabled mongdb"

systemctl start mongod &>>$LOGFILE
VALIDATE $? "Started the mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "edited the sed editor"

systemctl restart mongod &>>$LOGFILE
VALIDATE $? "Restarted the Mongodb"