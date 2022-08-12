#!/bin/bash
#
# Website Backup Shell Script
# by Andrew Currie (andrew@digitalpci.com)
#
# Performs a full backup of the specified database and document root. 
# Be sure to edit the configuration options at the beginning of the file to match your environment prior to executing.
# The end result will be one TAR archive with the name 'website-backup-(current-datestamp)'. 
# The backup includes the entire document root directory and also a 'database.sql' file containing a MySQL dump of the database.
#
# Begin Configuration Options (Specify which webroot and which database to backup.)
#
# Define The Website Document Root
  webrootdir=/var/www/html/site.com 
#
# Define The MySQL MySQL Database Name
  dbname=webmaste....     
#
# Define The MySQL Database Connection 
  dbhost=localhost
  dbuser=webjughjh
  dbpass=password
#
# Define The Default Backup Filename
  tarnamebase=Website-Backup-
  datestamp=`date +'%Y-%m-%d'`
#
# Define The Script Execution Point
  startdir=`pwd`
#
# Define The Temporary Working Directory
  tempdir=TemporaryBackup-$datestamp
#
# End Configuration Options
#
# Begin The Input Parameters Check
#
if test "$1" = ""
  then
    tarname=$tarnamebase$datestamp.tgz
  else
    tarname=$1
fi
#
# Begin the backup process.
#
echo "";
echo "******************************************";
echo " PREPARING TO BACKUP THE WEBSITE          ";
echo "******************************************";
echo "";
#
#
# Create The Temporary Working Directory
#
echo "";
echo "******************************************";
echo " SETTING UP A TEMPORARY BACKUP LOCATION   ";
echo "******************************************";
echo "";
#
mkdir $tempdir
echo "";
echo "******************************************";
echo " TEMPORARY BACKUP LOCATION SETUP COMPLETE ";
echo "******************************************";
echo "";
#
#
# Compress The Specified Document Root Into a TAR Archive 
echo "";
echo "**********************************************";
echo " COMPRESSING THE WEBSITE FILES IN $webrootdir ";
echo "**********************************************";
echo "";
cd $webrootdir
tar cf $startdir/$tempdir/webroot.tar .
echo "";
echo "**************************************************";
echo " WEBSITE FILES ARE NOW COMPRESSED INTO AN ARCHIVE ";
echo "**************************************************";
echo "";
echo "";
echo "*************Backup /etc/ssl & /etc/nginx*********";
echo "";
tar cfP $startdir/$tempdir/confs.tar /etc/ssl/ /etc/nginx/
#
# Peform mysqldump on the database specified in configuration options
#
echo "";
echo "***********************************************";
echo " PREPARING TO BACKUP THE DATABASE $dbname      ";
echo "***********************************************";
echo "";
echo $dbpass;
cd $startdir/$tempdir
#mysqldump -p$dbpass --user=$dbuser --pass=$dbpass --host=$dbhost --add-drop-table $dbname > database.sql
mysqldump -y -p --user=$dbuser --password=$dbpass --host=$dbhost --add-drop-table $dbname > database.sql
echo "";
echo "***********************************************";
echo " DATABASE BACKUP of $dbname COMPLETED          ";
echo "***********************************************";
echo "";
cp /root/{sitehealthcheck.sh,website.backup.sh} .
#
# Append The Website Files Archive with The MySQL Database Backup
#
echo "";
echo "***********************************************************";
echo " MERGING THE WEBROOT AND DATABASE BACKUPS INTO ONE ARCHIVE ";
echo "***********************************************************";
echo "";
tar czf $startdir/$tarname webroot.tar database.sql confs.tar sitehealthcheck.sh website.backup.sh
echo "";
echo "***********************************************************";
echo " WEBSITE BACKUP COMPLETED ($tarname)                       ";
echo "***********************************************************";
echo "";
echo "";
echo "***************Sent backup tar to backup machine **********";
rsync -avz -e 'ssh -p 22243' --progress $startdir/$tarname  root@1.2.3.4:/home/
#
# Cleanup Temporary Files
#
echo "";
echo "***********************************************************";
echo " PERFORMING SOME CLEANUP OPERATIONS                        ";
echo "***********************************************************";
echo "";
cd $startdir
rm -r $tempdir
echo "";
echo "***********************************************************";
echo " CLEANUP OPERATIONS COMPLETED                              ";
echo "***********************************************************";
echo "";
#
# Display The Confirmation Notice
#
echo "";
echo "***********************************************************";
echo " FULL WEBSITE BACKUP COMPLETED                             ";
echo "***********************************************************";
echo "";
#
