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

VALIDATE $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y  &>> $LOGFILE

VALIDATE $? "Enabling NodeJS:18"

dnf install nodejs -y  &>> $LOGFILE

VALIDATE $? "Installing NodeJS:18"

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app

VALIDATE $? "creating app directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOGFILE

VALIDATE $? "Downloading cart application"

cd /app 

unzip -o /tmp/cart.zip  &>> $LOGFILE

VALIDATE $? "unzipping cart"

npm install  &>> $LOGFILE

VALIDATE $? "Installing dependencies"

# use absolute, because cart.service exists there
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "Copying cart service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "cart daemon reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enable cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting cart"