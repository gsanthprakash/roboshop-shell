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

yum install mongodb -y &&>>$LOGFILE
VALIDATE $?