#!/bin/bash
#Authored By: Prasanjit Singh
#To get the customerlist from a specific database

#Declare variables
dbName=ffy_$1    # Will be obtained from the Php script $1
dbUser=$2
dbPass=$3
HostName=$4

#Stop script if syntax is wrong

if [ $# -ne 4 ]
then
        echo "All three parameters have not been provided correctly. Syntax: customerlist.sh dbName dbUser dbPass Hostname"
        exit;
else

mysql -u $dbUser -h $HostName -p$dbPass -Bse "SELECT * FROM ${dbName}.tbl_customer;"