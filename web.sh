#!/bin/bash

R="\e[31m"
Y="\e[32m"
G="\e[33m"
N="\e[0m"

USERID=$(id -u)
LOGSDIR=/tmp/
SCRIPT_NAME=$0
DATE=$(date +%F)
LOGFILE=$LOGSDIDR/$SCRIPT_NAME-$DATE.log

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ...$R FAILED $N "
        exit 1
    else
        echo -e "$2 ...$G SUCCESS $N "
    fi
}

if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: Not root user $N"
    exit 1
echo
    echo -e "$G You are Root USER $N"
fi

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "Installing the nginx"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "starting the nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "removing the default nginx"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "download the roboshop builds"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "moving to nginx directory"

unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "unzipping the web.zip"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "copying the roboshop.conf"

systemctl restart nginx &>> $LOGFILE
VALIDATE $? "restaring the nginx"




