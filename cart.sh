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
VALIDATE $? "disabling current nodejs package"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "enabling nodejs:18"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing the nodejs"

id roboshop
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "user added"
else
    echo "user already crated, skipped"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "app directory created"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? "downloading the cart zip file"

cd /app &>> $LOGFILE
VALIDATE $? "moving to app folder"

unzip /tmp/cart.zip &>> $LOGFILE
VALIDATE $? "unzipping the cart"

npm install  &>> $LOGFILE
VALIDATE $? "dependencies are installed"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE
VALIDATE $? "copying the cart.service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "system demaon reloading"

systemctl enable cart  &>> $LOGFILE
VALIDATE $? "enabling the cart"

systemctl start cart &>> $LOGFILE
VALIDATE $? "starting the cart"