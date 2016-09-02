#!/bin/bash


######################################################################################
## This script refreshs our working copies of following github repositories:
## - gluon (release, has to be changed manually in here, if there is a new releas )
## - ffwp-site (current master)
##
## The old and new git hashs are stored in files. 
## These files are checked by start-build.sh for deciding if a new build process 
## has to be started.
######################################################################################

cd ..
if [ ! -d "site" ]; then
        echo "This script must be called from within the site directory"
        return
fi

PATH_FFWP=/home/freifunk/.ffwp
PATH_LOG=$PATH_FFWP/fw/log
LOGFILE=$PATH_LOG/pull.log
FILE_SITE=$PATH_FFWP/fw/site.sha
FILE_SITE_OLD=$PATH_FFWP/fw/site.old.sha
FILE_GLUON=$PATH_FFWP/fw/gluon.sha
FILE_GLUON_OLD=$PATH_FFWP/fw/gluon.old.sha

rm $LOGFILE
date > $LOGFILE

#-------------------------------------------------------------------------------------
# refresh site directory
cd site
echo -e "--- site directory ---"  >> $LOGFILE
git remote -v  >> $LOGFILE 2>&1
echo branch >> $LOGFILE
git branch|grep \*  >> $LOGFILE 2>&1
SITE_HASH=(`git log --pretty=format:'%H' -n 1`)
echo $SITE_HASH >> $LOGFILE 2>&1
#echo $SITE_HASH > $FILE_SITE_OLD
touch $FILE_SITE_OLD

git checkout master > $LOGFILE 2>&1
git pull  > $LOGFILE 2>&1

SITE_HASH=(`git log --pretty=format:'%H' -n 1`)
echo $SITE_HASH >> $LOGFILE 2>&1
echo $SITE_HASH > $FILE_SITE


#-------------------------------------------------------------------------------------
# refresh gluon directory
cd ..
echo -e "" >> $LOGFILE
echo -e "" >> $LOGFILE
echo -e "--- gluon directory ---"  >> $LOGFILE
git remote -v  >> $LOGFILE 2>&1
echo branch  >> $LOGFILE
git branch|grep \*  >> $LOGFILE 2>&1
GLUON_HASH=(`git log --pretty=format:'%H' -n 1`)
echo $GLUON_HASH  >> $LOGFILE 2>&1
#echo $GLUON_HASH  > $FILE_GLUON_OLD
touch $FILE_GLUON_OLD

#git checkout master >> $LOGFILE 2>&1
#git pull  >> $LOGFILE 2>&1

#get latest tags
git fetch origin 'refs/tags/*:refs/tags/*' >> $LOGFILE 2>&1
#git tag -l >> $LOGFILE 2>&1
LATEST_TAG=(`git tag -l |tail -1`)
echo -e "pull latest tag: $LATEST_TAG"  >> $LOGFILE 2>&1
git checkout tags/$LATEST_TAG >> $LOGFILE 2>&1
git pull >> $LOGFILE 2>&1

GLUON_HASH=(`git log --pretty=format:'%H' -n 1`)
echo $GLUON_HASH  >> $LOGFILE 2>&1
echo $GLUON_HASH  > $FILE_GLUON

exit 0
