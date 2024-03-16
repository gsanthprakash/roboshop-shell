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

# Install nginx
dnf install nginx -y &>> $LOGFILE
VALIDATE $? "Installing nginx"

# Enable nginx
systemctl enable nginx &>> $LOGFILE
VALIDATE $? "Enabling nginx"

# Start nginx
systemctl start nginx &>> $LOGFILE
VALIDATE $? "Starting nginx"

# Remove default nginx content
rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "Removing default nginx content"

# Download roboshop builds
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "Downloading roboshop builds"

# Move to nginx directory
cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "Moving to nginx directory"

# Unzip roboshop builds
unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "Unzipping web.zip"

# Copy roboshop.conf to nginx configuration
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "Copying roboshop.conf"

# Restart nginx
systemctl restart nginx &>> $LOGFILE
VALIDATE $? "Restarting nginx"
