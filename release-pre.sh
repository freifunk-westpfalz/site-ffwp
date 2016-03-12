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

LOGFILE=../release-pre-$BRANCH.log
RESULT=0

rm -f $LOGFILE
date | tee -a $LOGFILE

echo "   Delete old /$BRANCH files" | tee -a $LOGFILE
rm -rf ../img/$BRANCH/factory
rm -rf ../img/$BRANCH/sysupgrade
rm -f ../img/$BRANCH/.build.txt
rm -f ../img/$BRANCH/.start-build.txt

echo "   Copy ../img/.pre_$BRANCH to /$BRANCH" | tee -a $LOGFILE
cp -R ../img/.pre_$BRANCH/factory ../img/$BRANCH/
cp -R ../img/.pre_$BRANCH/sysupgrade ../img/$BRANCH/
cp ../img/.pre_$BRANCH/.build.txt ../img/$BRANCH/
cp ../img/.pre_$BRANCH/.start-build.txt ../img/$BRANCH/

echo "   Change group to ffadm" | tee -a $LOGFILE
chown -R :ffadm ../img/$BRANCH
echo "   Set file attributes to 'group writable'" | tee -a $LOGFILE
chmod -R g+w ../img/$BRANCH

ls -la ../img/$BRANCH

date | tee -a $LOGFILE
echo "Done :)         $RESULT error/s"| tee -a $LOGFILE


cd site
exit 0

