#!/bin/sh
#
# CodeBackup Script by Piper ## www.binpipe.com
#LEGEND
# dirs_to_backup     : Space delimited list of directories to backup. 
# 				       If multiple directories are listed use quotes around the argument.
# backup_store_dir : The directory to save files to.
# [key] 			 : An optional parameter (hostname is used if not specified) that is 
#     		           used to name the backup files.  Particularly necessary if you have 
#     		           multiple computers backing up to the same dump_to path.
#USAGE
# 					   codebackup.sh dirs_to_backup dump_to [key]
if [ $# -lt 3 ]
then
   echo "usage: codebackup.sh dirs_to_backup dump_to [key]"
   exit;
fi

COMPUTER=`hostname`

if [ $# -gt 3 ]
then
   COMPUTER=$3
fi

DIRECTORIES=$1
BACKUPDIR=$2
TAR=/bin/tar		    # name and location of tar command
CONFIGS=/etc			# name and location of config directories you wish to backup

PATH=/usr/local/bin:/usr/bin:/bin
DOW=`date +%a`              # Day of the week e.g. Mon
DOM=`date +%d`              # Date of the Month e.g. 27
DM=`date +%d%b`             # Date and Month e.g. 27Sep
MOY=`date +%b_%Y`			# Month of Year e.g. Jun_2012
DAT=`date +%d%b%Y`          # Date

#########--What the Script Does--######## 
# On the 1st of the month a full backup is made and kept in a separate folder.
# Every Sunday a full backup for the config directory like /etc
# The rest of the time a daily backup is made. All files older than 10 days are deleted. Monthly snapshots older that 6 months are deleted.
#Cron example: 30 21 * * *	codebackup.sh /var/www/vhosts/dynamiclevels.com /backup DL-Codebase
#
if [ $DOM = "01" ]; then  # monthly snapshots full backup in a separate directory
	mkdir $BACKUPDIR/$MOY
	$TAR -czf $BACKUPDIR/$MOY/$COMPUTER-$DM-Archive.tgz $DIRECTORIES
fi

if [ $DOW = "Sun" ]; then # weekly full backup of configs
 	
	$TAR -z -c -f $BACKUPDIR/$COMPUTER-$DAT-CONFIGS.tgz $CONFIGS

else    # make Daily backup & Remove Files Older than 10 days

	$TAR -z -c -f $BACKUPDIR/$COMPUTER-$DAT.tgz $DIRECTORIES
	find $BACKUPDIR/*.tgz -mtime +9 -exec rm {} \;
fi

# Also Remove Anything older than 6 months#
find $BACKUPDIR/ -amin +259200 -exec /bin/rm -rf {} \;