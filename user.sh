#!/bin/bash

DATE=$(date +%F)

R="\e[31m"
G="\e[32m"
N="\e[0m"

LOGSDIR=/home/centos/shell-script
SCRIPT_NAME=$0
LOGFILE=$LOGSDIDR/$SCRIPT_NAME-$DATE.log

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

if [ $USERID -ne 0 ]
then    
    echo "ERROR: Not root user"
    exit 1
else
    echo "you are root user"
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "disabling nodejs present version"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabling nodej:18 Version"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing Nodejs"

id roboshop &>> $LOGFILE
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo "already created user, skipping"
fi

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
VALIDATE $? "downloading the user package"

cd /app  &>> $LOGFILE
VALIDATE $? "moving to directory app"

unzip /tmp/user.zip &>> $LOGFILE
VALIDATE $? "uzipping the user package"

npm install  &>> $LOGFILE
VALIDATE $? "npm install"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>> $LOGFILE
VALIDATE $? "copying the user.service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "deamon-reloading"

systemctl enable user  &>> $LOGFILE
VALIDATE $? "enabling user"

systemctl start user &>> $LOGFILE
VALIDATE $? "starting user"

cp /home/centos/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copying the mongo.repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "installing the mongodb-org-shell"

mongo --host mongodb.gspaws.online </app/schema/user.js &>> $LOGFILE
VALIDATE $? "downloading the user schema"