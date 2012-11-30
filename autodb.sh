#!/bin/bash
#Authored By: Prasanjit Singh
##Creates a database with inputs from php file and imports db structure from a common location
##Checks and sets proper file permissions to the new subdomain
##Edits the DB config files database.php and config.php

#Declare variables
dbName=ffy_$1    # Will be obtained from the Php script $1
dbUser=$2
dbPass=$3
HostName=$4
sqlpath="/var/www/scripts/ffy_base.sql"
basepath=/var/www/html/Flowersforyou/php/users/$1
cfg_base=/var/www/scripts/config.php
dbcfg_base=/var/www/scripts/database.php
cfg=/var/www/html/Flowersforyou/php/users/$1/system/application/config/config.php
dbcfg=/var/www/html/Flowersforyou/php/users/$1/system/application/config/database.php
##Var's for file edit
base_url="\$config['base_url']     = \"http://\".\$_SERVER['HTTP_HOST'].\"/Flowersforyou/php/users/"$1/\"\;
#echo $base_url
#exit
#Stop script if syntax is wrong

if [ $# -ne 4 ]
then
        echo "All three parameters have not been provided correctly. Syntax: autodb.sh dbName dbUser dbPass Hostname"
        exit;
else

#Check if database exists then exit else Create Database & Apply Privileges

DBEXISTS=$(mysql -u $dbUser -h $HostName -p$dbPass --batch --skip-column-names -e "SHOW DATABASES LIKE '"$dbName"';" | grep "$dbName" > /dev/null; echo "$?")
if [ $DBEXISTS -eq 0 ];
then
        echo "A database with the name $dbName already exists. Cannot create database. Exiting!"
        exit;
else
mysql -u $dbUser -h $HostName -p$dbPass -Bse "CREATE DATABASE $dbName;"
mysql -u $dbUser -h $HostName -p$dbPass -Bse "GRANT ALL ON ${dbName}.* to $dbUser@$HostName identified by '${dbPass}';" 

#Import Database

mysql -u $dbUser -h $HostName -p$dbPass $dbName < $sqlpath

#Apply Permissions

chmod -R 777 $basepath
chown -R phpadmin.phpadmin $basepath

#Edit the config files: database.php and config.php by string manipulation
#config.php
yes | cp -p $cfg_base $cfg
sed "15i\\
$base_url" $cfg_base > $cfg
#database.php
yes | cp -p $dbcfg_base $dbcfg
sed -i "s/Xm01/$dbName/g" $dbcfg
sed -i "s/Xm02/$dbUser/g" $dbcfg
sed -i "s/Xm03/$dbPass/g" $dbcfg
sed -i "s/Xm04/$HostName/g" $dbcfg
fi
fi
#Apply Permissions

chmod -R 777 $basepath
chown -R phpadmin.phpadmin $basepath

#Log the outcome

echo "Subdomain Created Successfully !"