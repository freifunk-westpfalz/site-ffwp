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

LOGFILE=../pull.log

rm $LOGFILE
date > $LOGFILE

#-------------------------------------------------------------------------------------
# refresh site directory
cd site
echo -e "--- site directory ---"  >> ../$LOGFILE
git remote -v  >> ../$LOGFILE 2>&1
echo branch >> ../$LOGFILE
git branch|grep \*  >> ../$LOGFILE 2>&1
SITE_HASH=(`git log --pretty=format:'%H' -n 1`)
echo $SITE_HASH >> ../$LOGFILE 2>&1
echo $SITE_HASH > ../../site.hash.old

git checkout 2015.2-dev > ../$LOGFILE 2>&1
git pull  > ../$LOGFILE 2>&1

SITE_HASH=(`git log --pretty=format:'%H' -n 1`)
echo $SITE_HASH >> ../$LOGFILE 2>&1
echo $SITE_HASH > ../../site.hash


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
echo $GLUON_HASH  > ../gluon.hash.old

#git checkout master >> $LOGFILE 2>&1
#git pull  >> $LOGFILE 2>&1

#git fetch origin 'refs/tags/*:refs/tags/*' >> $LOGFILE 2>&1
#git tag -l >> $LOGFILE 2>&1
git checkout tags/v2016.1 >> $LOGFILE 2>&1
git pull >> $LOGFILE 2>&1

GLUON_HASH=(`git log --pretty=format:'%H' -n 1`)
echo $GLUON_HASH  >> $LOGFILE 2>&1
echo $GLUON_HASH  > ../gluon.hash

cd site

exit 0
