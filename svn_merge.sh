#!/bin/sh

## A simple shell script used to merge braches of Subversion. -- Work In Progress

versions=`svn log $2 --stop-on-copy | grep '^r[0-9]*' | awk '{print $1}'`
head_version=`echo $versions | awk '{print $1}' | grep -o '[0-9]*$'`
tail_version=`echo $versions | awk '{print $NF}' | grep -o '[0-9]*$'`
merge_cmd="svn merge -r $tail_version:$head_version $2 ."
 
echo 'Preparing environment:'
rm -rf svnmerge_tmp && mkdir svnmerge_tmp && cd khotyn_tmp
echo "Preparing environment done!\nChecking out $1"
svn co $1 .
echo "Checking out $1 done!\nMerging branches:$merge_cmd"
$merge_cmd
echo "Merging branches done:$merge_cmd"
