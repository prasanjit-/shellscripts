#!/bin/bash
##To sync two database tables by Prasanjit (HOST1 ---> HOST2)
##Script runs at HOST2 (Host1 is Remote source & Host2 is local)

#Ideas-to-be-implemented#
#mysqldump -u user1 -ppassword1 -h host1 [some options here] db1 stage_customer_log | mysql -u user2 -ppassword2 -h host2 [some options here] db2
#mysqldump -u user1 -ppassword1 --add-drop-table databasename tablename > dump.sql
#usually this may be done from server to server using SSH-port-forwarding: ssh -f -N -L 3307:localhost:3306 nmmn (nmmn is one of my SSH-shortcuts, use a server-name+port instead);
#for multiple tables use the param --tables table1 table2
# --add-drop-table          Add a DROP TABLE statement before each CREATE TABLE statement.

###-------Declare Variables---------###

HOST1_IP=198.244.49.16
SQLUSR1=techshuuser
SQLPASS1=""
DBNAME1=""
TABLENAME1=""
HOST2_IP=localhost
SQLUSR2=""
SQLPASS2=""
DBNAME2=""
TABLENAME2=""

###---------------------------------###

#Import data from HOST1 to HOST2 and insert
mysqldump -u $SQLUSR1 -p$SQLPASS1 -h $HOST1_IP --add-drop-table $DBNAME1 $TABLENAME1 | mysql -u $SQLUSR2 --password=$SQLPASS2 $DBNAME2
#Rename the table
mysql -u $SQLUSR2 --password=$SQLPASS2 -e "use rp_workflow; DROP TABLE tbl_bpd_feedback_unsubscribe;"
mysql -u $SQLUSR2 --password=$SQLPASS2 -e "use rp_workflow; RENAME TABLE feedback_unsubscribe TO tbl_bpd_feedback_unsubscribe;"
#EOF