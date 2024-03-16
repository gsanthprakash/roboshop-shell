#!/bin/bash

R="\e[31m"
G="\e[32m"
N="\e[0m"

MONGODB_HOST=gspaws.online

LOGSDIR="/home/centos/Shell-Script"
SHELL_SCRIPT="$0"
DATE=$(date +%F)
LOGFILE="$LOGSDIDR/$SHELL_SCRIPT-$DATE.log"

USERID=$(id -u)

if [[ $USERID -ne 0 ]]
then 
    echo -e "$R ERROR, please proceed with root access $N"
else    
    echo -e "$G You are root user $N"
fi

VALIDATE(){
    if [[ $1 -ne 0 ]]
    then 
        echo "$2 $R ... FAILURE $N"
    else
        echo "$2 $G .... SUCCESS $N"
    fi
}

dnf module disable nodejs -y $>>$LOGFILE
VALIDATE $? "disabling the nodejs latest"

dnf module enable nodejs:18 -y $>>$LOGFILE
VALIDATE $? "enabling nodejs:18"

dnf install nodejs -y $>>$LOGFILE
VALIDATE $? "Installing Nodejs"

useradd -M roboshop $>>$LOGFILE
VALIDATE $? "useradding to roboshop"

mkdir -vp /app >> $LOGFILE
VALIDATE $? "app directory adding"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "downloading the catalouge"

cd /app $>>$LOGFILE
VALIDATE $? "entering to app directory"

unzip -o /tmp/catalogue.zip >> $LOGFILE
VALIDATE $? "unzipping the catalogue"

npm install $>>$LOGFILE
VALIDATE $? "NPM installing"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service $>>$LOGFILE
VALIDATE $? "copying the catalogue.service"

systemctl daemon-reload $>>$LOGFILE
VALIDATE $? "deamon reloading"

systemctl enable catalogue $>>$LOGFILE
VALIDATE $? "enabling catalogue"

systemctl start catalogue $>>$LOGFILE
VALIDATE $? "Starting the catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo $>>$LOGFILE
VALIDATE $? "copying the mongo.repo"

dnf install mongodb-org-shell -y $>>$LOGFILE
VALIDATE $? "Installing the Mongodb-Org-Shell"

mongo --host $MONGODB_HOST </app/schema/catalogue.js $>>$LOGFILE
VALIDATE $? "connecting the mongdb Server"