#!/bin/bash

#Createing manifest file for chosen branch (arg1)

# if version is unset, will use the default nightly version from site.mk
#VERSION=0.5.0
# branch must be set to either nightly, beta or stable
BRANCH=$1
#debug switch: DEBUG=V\=s
#DEBUG=V\=s
DEBUG=

if test $# -eq 0; then
        echo "   Error: This script must have one of the following values as first parameter: beta, stable"
	exit 1
fi

cd ..
# ----folder: gluon----
if [ ! -d "site" ]; then
        echo "   Error: This script must be called from within the site directory"
        exit 1
fi

LOGPATH=/home/freifunk/.ffwp/fw/log
LOGFILE=$LOGPATH/release-pre-$BRANCH.log
WWWROOT=/srv/firmware
RESULT=0

if [[ $BRANCH == "beta" ]];then
        SOURCEPATH=$WWWROOT/.pre_$BRANCH
else
        if [[ $BRANCH == "stable" ]];then
	        SOURCEPATH=$WWWROOT/.pre_$BRANCH
        else
                echo "   Error: wrong parameter, use either \"beta\" or \"stable\"!"
                exit 1
        fi
fi

rm -f $LOGFILE
date | tee -a $LOGFILE

echo "   Delete old /$BRANCH files" | tee -a $LOGFILE
rm -rf $WWWROOT/$BRANCH/factory
rm -rf $WWWROOT/$BRANCH/sysupgrade
rm -f $WWWROOT/$BRANCH/.build.txt
rm -f $WWWROOT/$BRANCH/.start-build.txt
rm -f $WWWROOT/$BRANCH/.build_overview.txt

echo "   Copy $WWWROOT/.pre_$BRANCH to /$BRANCH" | tee -a $LOGFILE
cp -R $WWWROOT/.pre_$BRANCH/factory $WWWROOT/$BRANCH/
cp -R $WWWROOT/.pre_$BRANCH/sysupgrade $WWWROOT/$BRANCH/
cp $WWWROOT/.pre_$BRANCH/.build.txt $WWWROOT/$BRANCH/
cp $WWWROOT/.pre_$BRANCH/.build_overview.txt $WWWROOT/$BRANCH/

echo "   Change user:group to freifunk:freifunk" | tee -a $LOGFILE
chown -R freifunk:freifunk $WWWROOT/$BRANCH
echo "   Set file attributes to 'group writable'" | tee -a $LOGFILE
chmod -R 755 $WWWROOT/$BRANCH

ls -la $WWWROOT/$BRANCH

date | tee -a $LOGFILE
echo "Done :)         $RESULT error/s"| tee -a $LOGFILE


cd site
exit 0

