#!/bin/bash
#
# webhits -- Reports amount of website hits, total values and per user hits by parsing the Apache Access log
# Author: Prasanjit 
#
########
# Declare the apache access log path by either using 
WEBLOG="/var/log/httpd/access_log"

if [ "$1" = "" ]; then
 echo "Usage: `basename $0` <user1> <user2> osv.."
 exit
fi
date > wtstat
echo "`cat $WEBLOG|wc -l` total hits on `hostname` " >>wtstat
function_treff() {
 echo "`grep $i $WEBLOG|wc -l` hits on $i" >>wtstat
}
for i in $* 
do
 function_treff
done 
sort -r wtstat -o wtstat
more wtstat
rm wtstat
