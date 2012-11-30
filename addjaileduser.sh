#!/bin/bash
##By: Prasanjit -- Script to create jailed SFTP webuser
##Do the needful mentioned in http://www.binpipe.com/2012/11/restrict-users-to-home-directory-chroot.html before creating this user.
##Also activate apache mod_userdir
##SYNTAX: sh addjaileduser.sh <username>
mkdir -p /var/www/html/$1/public_html
useradd $1
usermod -g sftponly $1 ; usermod -s /bin/false $1
chmod 755 /var/www/html/$1/ ; chmod 755 /var/www/html/$1 ; chown root:root /var/www/html/$1  ; chown $1:sftponly /var/www/html/$1/public_html
passwd $1