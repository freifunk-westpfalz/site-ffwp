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
LOGFILE=$LOGPATH/copy-to-pre-$BRANCH.log
WWWROOT=/srv/firmware
GLUONPATH=/home/freifunk/gluon
RESULT=0

if [[ $BRANCH == "beta" ]];then
	SOURCEPATH=$GLUONPATH/output/images
else 
	if [[ $BRANCH == "stable" ]];then
		SOURCEPATH=$WWWROOT/beta
	else
		echo "   Error: wrong parameter, use either \"beta\" or \"stable\"!"
		exit 1
	fi
fi

echo "   SOURCEPATH: $SOURCEPATH" | tee -a $LOGFILE

rm -f $LOGFILE
date | tee -a $LOGFILE

echo "   Delete old .pre_$BRANCH files" | tee -a $LOGFILE
rm -rf $WWWROOT/.pre_$BRANCH/factory
rm -rf $WWWROOT/.pre_$BRANCH/sysupgrade
rm -f $WWWROOT/.pre_$BRANCH/.build_overview.txt
rm -f $WWWROOT/.pre_$BRANCH/.build.txt

echo "   Copy $SOURCEPATH to .pre_$BRANCH" | tee -a $LOGFILE
cp -R $SOURCEPATH/factory $WWWROOT/.pre_$BRANCH/
cp -R $SOURCEPATH/sysupgrade $WWWROOT/.pre_$BRANCH/
cp $SOURCEPATH/.build_overview.txt $WWWROOT/.pre_$BRANCH/
cp $SOURCEPATH/.build.txt $WWWROOT/.pre_$BRANCH/

echo "   Change user:group to freifunk:freifunk" | tee -a $LOGFILE
chown -R freifunk:freifunk $WWWROOT/.pre_$BRANCH
echo "   Set file attributes to 'group writable'" | tee -a $LOGFILE
chmod -R 754 $WWWROOT/.pre_$BRANCH

ls -la $WWWROOT/.pre_$BRANCH

date | tee -a $LOGFILE
echo "Done :)         $RESULT error/s"| tee -a $LOGFILE


cd site
exit 0

