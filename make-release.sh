#!/bin/bash

######################################################################################
## Thanks to FFSAAR for the base of this script
## see also: https://github.com/freifunk-saar/gluon-site/blob/master/make-release.sh
######################################################################################

## This script will compile Gluon for all architectures, create the
## manifest and sign it. For that, you must have clone gluon and have a
## valid site config. Additionally, the signing key must be present in
## ../../ecdsa-key-secret.
## Call from site directory with the version and branch variables
## properly configured in this script.

# if version is unset, will use the default nightly version from site.mk
#VERSION=0.5.0
# branch must be set to either nightly, beta or stable
BRANCH=nightly
#debug switch: DEBUG=V\=s
#DEBUG=V\=s
DEBUG=

#git pull
cd ..
if [ ! -d "site" ]; then
	echo "This script must be called from within the site directory"
	return
fi

#git pull

#if [[ 1 = 2 ]]; then

LOGFILE=../build.log

rm $LOGFILE
date | tee -a $LOGFILE
rm -r output/images
#for TARGET in  ar71xx-generic
for TARGET in  ar71xx-generic ar71xx-nand mpc85xx-generic x86-generic x86-kvm_guest
do
	date | tee -a $LOGFILE
	if [ -z "$VERSION" ]
	then
		echo "Starting work on target $TARGET" | tee -a $LOGFILE
		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable update" >> $LOGFILE
		make GLUON_TARGET=$TARGET GLUON_BRANCH=stable update >> $LOGFILE 2>&1
		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable clean" >> $LOGFILE
		make GLUON_TARGET=$TARGET GLUON_BRANCH=stable clean >> $LOGFILE 2>&1
		echo -e "\n\n\nmake $DEBUG GLUON_TARGET=$TARGET GLUON_BRANCH=stable -j7" >> $LOGFILE
		make $DEBUG GLUON_TARGET=$TARGET GLUON_BRANCH=stable -j7 >> $LOGFILE 2>&1
		if [ $? -eq 0 ]; then
			RESULT=0 
			#ok
		else
			RESULT=1
		fi
		echo -e "\n\n\n============================================================\n\n" >> $LOGFILE
	else
		echo "Starting work on target $TARGET" | tee -a $LOGFILE
		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION update" >> $LOGFILE
		make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION update >> $LOGFILE 2>&1
		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION clean" >> $LOGFILE
		make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION clean >> $LOGFILE 2>&1
		echo -e "\n\n\nmake $DEBUG GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j7" >> $LOGFILE
		make $DEBUG GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j7 >> $LOGFILE 2>&1
                if [ $? -eq 0 ]; then
                        RESULT=0
                else
                        RESULT=1
                fi
		echo -e "\n\n\n============================================================\n\n" >> $LOGFILE
	fi
done

if [ $RESULT -ne 0 ]; then
	echo "Compilation FAILED, see build.log" | tee -a $LOGFILE
	cd site
	exit 1
else
	echo "Compilation complete, creating manifest(s)" | tee -a $LOGFILE

	echo -e "make GLUON_BRANCH=nightly manifest" >> $LOGFILE
	make GLUON_BRANCH=nightly manifest >> $LOGFILE 2>&1
	echo -e "\n\n\n============================================================\n\n" >> $LOGFILE

	if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
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

	echo "Manifest creation complete, signing manifest" | tee -a $LOGFILE

	echo -e "contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/nightly.manifest" >> $LOGFILE
	contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/nightly.manifest >> $LOGFILE 2>&1

	if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
	then
		echo -e "contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/beta.manifest" >> $LOGFILE
		contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/beta.manifest >> $LOGFILE 2>&1
	fi

	if [[ "$BRANCH" == "stable" ]]
	then
		echo -e "contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/stable.manifest" >> $LOGFILE
		contrib/sign.sh ../ecdsa-key-secret output/images/sysupgrade/stable.manifest >> $LOGFILE 2>&1
	fi

	echo -e "--- md5 erzeugen ---" >> $LOGFILE
	cd output/images/factory
	md5sum gluon* > md5.txt

	cd ../sysupgrade
	md5sum gluon* > md5.txt

	cd ../../../

	date >> $LOGFILE
	echo "Done :)" | tee -a $LOGFILE
fi

cd site
exit 0
