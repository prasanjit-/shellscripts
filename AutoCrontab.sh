#!/bin/sh
# Auto Crontab Shell Script for detecting no of welcome packs to be generated and sent to customers via cron
# The logic is : If welcome packs <= 25 then run 1 cron, If 25 < n <50 then 2 cron and so on.
# cronjob runs as cronman user's cron
# This script runs once a day as root's cron
#By Prasanjit  ##
#cron_gsmpwp.sh
######################################
FILE=/var/spool/cron/cronman
LOG=/var/log/GSM_Route_Post_Welcome_Pack.log
#Clear existing crontab#
> $FILE
#Get total count for all brands 
SQL=`mysql -uroot -pmysql_password -e "select TotalCount from (
select distinct deleg.TAS_UID as 'TaskID', (select cont.CON_VALUE from wf_gsm.CONTENT cont where deleg.TAS_UID=cont.CON_ID and 
cont.CON_CATEGORY='TAS_TITLE') as 'TaskName',count(deleg.TAS_UID) as 'TotalCount' 
from wf_gsm.APPLICATION app, rp_gsm.teleus_sales_details sale, wf_gsm.APP_DELEGATION deleg 
where app.PRO_UID='8948545874f966410187186029693045' and sale.APP_UID=app.APP_UID and date_format(sale.SaleDate,'%Y-%m-%d')>='2012-05-01' and 
date_format(sale.SaleDate,'%Y-%m-%d')<=curdate() and deleg.DEL_THREAD_STATUS='OPEN' and app.APP_UID=deleg.APP_UID 
and app.APP_STATUS<>'DRAFT' and deleg.TAS_UID='3333125734f9664101c2272063759985'
) outertable1;"`
COUNT=`echo $SQL | awk -F' ' '{print $2}'`
echo $COUNT
#Conditions for appending to crontab File
if [ $COUNT -le 25 ]; then  # Execute 1 cron batch
> $FILE
echo "##--GSM Route_Post_Welcome_Pack CRON---## " >> $FILE
echo "50 03 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
#Logging Function
# Print Set Crontab to log File
    echo `date` > $LOG
	echo Current Count is $COUNT >> $LOG
	cat  $FILE >> $LOG
exit	
#
elif [ $COUNT -le 50 ]; then  # Execute 2 cron batches
> $FILE
echo "##--GSM Route_Post_Welcome_Pack CRON---## " >> $FILE
echo "50 03 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
echo "15 04 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
#Logging Function
# Print Set Crontab to log File
    echo `date` > $LOG
	echo Current Count is $COUNT >> $LOG
	cat  $FILE >> $LOG
exit	
elif [ $COUNT -le 75 ]; then  # Execute 3 cron batches
> $FILE
echo "##--GSM Route_Post_Welcome_Pack CRON---## " >> $FILE
echo "50 03 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
echo "15 04 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
echo "40 04 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
#Logging Function
# Print Set Crontab to log File
    echo `date` > $LOG
	echo Current Count is $COUNT >> $LOG
	cat  $FILE >> $LOG
exit	
elif [ $COUNT -gt 75 ]; then  # Execute 4 cron batches
> $FILE
echo "##--GSM Route_Post_Welcome_Pack CRON---## " >> $FILE
echo "50 03 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
echo "15 04 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
echo "40 04 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
echo "05 05 * * * lynx http://IP-ADD/GSM_Route_Post_Welcome_Pack.php" >> $FILE
#Logging Function
# Print Set Crontab to log File
    echo `date` > $LOG
	echo Current Count is $COUNT >> $LOG
	cat  $FILE >> $LOG
exit		
fi