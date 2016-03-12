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

LOGFILE=../copy-to-pre-$BRANCH.log
RESULT=0

rm -f $LOGFILE
date | tee -a $LOGFILE

echo "   Delete old .pre_$BRANCH files" | tee -a $LOGFILE
rm -rf ../img/.pre_$BRANCH/factory
rm -rf ../img/.pre_$BRANCH/sysupgrade
rm -f ../img/.pre_$BRANCH/.build.txt
rm -f ../img/.pre_$BRANCH/.start-build.txt

echo "   Copy output/images/ to .pre_$BRANCH" | tee -a $LOGFILE
cp -R output/images/factory ../img/.pre_$BRANCH/
cp -R output/images/sysupgrade ../img/.pre_$BRANCH/
cp output/images/.build.txt ../img/.pre_$BRANCH/
cp output/images/.start-build.txt ../img/.pre_$BRANCH/

echo "   Change group to ffadm" | tee -a $LOGFILE
chown -R :ffadm ../img/.pre_$BRANCH
echo "   Set file attributes to 'group writable'" | tee -a $LOGFILE
chmod -R g+w ../img/.pre_$BRANCH

ls -la ../img/.pre_$BRANCH

date | tee -a $LOGFILE
echo "Done :)         $RESULT error/s"| tee -a $LOGFILE


cd site
exit 0

