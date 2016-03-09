#!/bin/bash

#Createing manifest file for chosen branch (arg1)

# if version is unset, will use the default nightly version from site.mk
#VERSION=0.5.0
# branch must be set to either nightly, beta or stable
BRANCH=$1
#debug switch: DEBUG=V\=s
#DEBUG=V\=s
DEBUG=

cd ..
if [ ! -d "site" ]; then
	echo "This script must be called from within the site directory"
	return
fi

LOGFILE=../make-manifest-$BRANCH.log
RESULT=0

rm -f $LOGFILE
date | tee -a $LOGFILE

	#echo -e "make GLUON_BRANCH=nightly manifest" >> $LOGFILE
	#make GLUON_BRANCH=nightly manifest >> $LOGFILE 2>&1
	#echo -e "\n\n\n============================================================\n\n" >> $LOGFILE

	if [[ "$BRANCH" == "beta" ]]
	then
		echo -e "make GLUON_BRANCH=beta manifest" >> $LOGFILE
		make GLUON_BRANCH=beta manifest >> $LOGFILE 2>&1
		echo -e "\n\n\n============================================================\n\n" >> $LOGFILE
	fi

	if [[ "$BRANCH" == "stable" ]]
	then
		echo -e "make GLUON_BRANCH=stable manifest" >> $LOGFILE
		make GLUON_BRANCH=stable manifest >> $LOGFILE 2>&1
		echo -e "\n\n\n============================================================\n\n" >> $LOGFILE
	fi

	echo "Manifest creation complete, no auto-signing for branch $BRANCH" | tee -a $LOGFILE


	#echo -e "contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/nightly.manifest" >> $LOGFILE
	#contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/nightly.manifest >> $LOGFILE 2>&1

	#if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
	#then
	#	echo -e "contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/beta.manifest" >> $LOGFILE
	#	contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/beta.manifest >> $LOGFILE 2>&1
	#fi

	#if [[ "$BRANCH" == "stable" ]]
	#then
	#	echo -e "contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/stable.manifest" >> $LOGFILE
	#	contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/stable.manifest >> $LOGFILE 2>&1
	#fi

	#echo -e "--- md5 erzeugen ---" >> $LOGFILE
	#cd output/images/factory
	#md5sum gluon* > md5.txt

	#cd ../sysupgrade
	#md5sum gluon* > md5.txt

	cd ../../../

	date >> $LOGFILE
	echo "Done :)         $RESULT error/s"| tee -a $LOGFILE


cd site
exit 0
