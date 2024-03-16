#!/bin/bash

# Define color codes for better readability
R="\e[31m"  # Red color
Y="\e[33m"  # Yellow color
G="\e[32m"  # Green color
N="\e[0m"   # Reset color

USERID=$(id -u)
LOGSDIR=/tmp/
SCRIPT_NAME=$0
DATE=$(date +%F)
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

# Function to validate the result of a command and print status
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ...$R FAILED $N"
        exit 1
    else
        echo -e "$2 ...$G SUCCESS $N"
    fi
}

# Check if the user is root
if [ $USERID -ne 0 ]
then 
    echo -e "$R ERROR: Not root user $N"
    exit 1
fi

# Inform that the user is root
echo -e "\n$G You are Root USER $N"

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
