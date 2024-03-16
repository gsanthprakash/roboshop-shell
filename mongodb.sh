#!/bin/bash

USERID=$(id -u)
DATE=$(date +%F)

R="\e[31m"
G="\e[32m"
N="\e[0m"

LOGSDIR=/home/centos/shell-script
SCRIPT_NAME=$0
LOGSFILE=$LOGSDIDR/$SCRIPT_NAME-$DATE.log

if [$USERID -ne 0]
then
    echo $R ERROR: please proceed with Root user $N
    exit 1
else
    echo $G You are root user $N
fi


yum install mongodb -y &&>>$LOGFILE
VALIDATE $?