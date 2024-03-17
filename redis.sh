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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "installing the redis from RPM"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "enabling redis"

dnf install redis -y &>> $LOGFILE
VALIDATE $? "Installating Redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $LOGFILE
VALIDATE $? "Editing the SED editor by updating IP"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "enabling the redis"

systemctl start redis &>> $LOGFILE
VALIDATE $? "started the redis"