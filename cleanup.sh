#!/bin/bash
#Authored By: Prasanjit Singh
##Cleansup the subdomain created

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
        echo "All three parameters have not been provided correctly. Syntax: cleanup.sh subdomainname dbUser dbPass Hostname"
        exit;
else

#Check if database exists then drop Database/Codebase exit else Show Error.

DBEXISTS=$(mysql -u $dbUser -h $HostName -p$dbPass --batch --skip-column-names -e "SHOW DATABASES LIKE '"$dbName"';" | grep "$dbName" > /dev/null; echo "$?")
if [ $DBEXISTS -eq 0 ];
then
        echo "Clearing Database..."
		mysql -u $dbUser -h $HostName -p$dbPass -Bse "DROP DATABASE $dbName;"
		echo "DONE"
		echo "Clearing Files..."
		rm -rf $basepath
		#Log the outcome
		echo "Subdomain Deleted Successfully !"
        exit;
else
		echo "Please Check the Subdomain name you provided. Subdomain does not exist!"
fi
fi