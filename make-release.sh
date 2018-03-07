#!/bin/bash

######################################################################################
## Thanks to FFSAAR for the base of this script
## see also: https://github.com/freifunk-saar/gluon-site/blob/master/make-release.sh
######################################################################################

## This script will compile Gluon for all architectures, create the
## manifest and sign it. For that, you must have clone gluon and have a
## valid site config. Additionally, the signing key must be present in
## $PATH_FFWP/fw/autobuilder.secret
## Call from site directory with the version and branch variables
## properly configured in this script.

# if version is unset, will use the default nightly version from site.mk
#VERSION=0.5.0
# branch must be set to either nightly, beta or stable
BRANCH=nightly
#debug switch: DEBUG=V\=s
#DEBUG=V\=s
DEBUG=

PATH_GLUON=/home/freifunk/gluon
PATH_FFWP=/home/freifunk/.ffwp
PATH_LOG=$PATH_FFWP/fw/log
FILE_SECRET=$PATH_FFWP/fw/autobuilder.secret
CPU_CNT=`cat /proc/cpuinfo|grep ^processor|wc -l`
CPU_CNT=$(($CPU_CNT-1))
cd ..
VERSION=`make show-release`
if [ ! -d "site" ]; then
	echo "This script must be called from within the site directory"
	exit 1
fi

LOGFILE=$PATH_LOG/build.log
RESULT=0

rm $LOGFILE
date | tee -a $LOGFILE
rm -r $PATH_GLUON/output/images

echo -e "\n\n\nmake dirclean" >> $LOGFILE
make dirclean | tee -a $LOGFILE
echo -e "\n\n\n" >> $LOGFILE

#for TARGET in  ar71xx-tiny
for TARGET in  ar71xx-generic ar71xx-tiny ar71xx-nand mpc85xx-generic ramips-mt7621 x86-generic x86-geode x86-64
do
	date | tee -a $LOGFILE
	if [ -z "$VERSION" ]
	then
		echo "Starting work on target $TARGET (1)" | tee -a $LOGFILE
		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable update" >> $LOGFILE
		make GLUON_TARGET=$TARGET GLUON_BRANCH=stable update >> $LOGFILE 2>&1
		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable clean" >> $LOGFILE
		make GLUON_TARGET=$TARGET GLUON_BRANCH=stable clean >> $LOGFILE 2>&1
		echo -e "\n\n\nmake $DEBUG GLUON_TARGET=$TARGET GLUON_BRANCH=stable -j$CPU_CNT" >> $LOGFILE
		make $DEBUG GLUON_TARGET=$TARGET GLUON_BRANCH=stable -j$CPU_CNT >> $LOGFILE 2>&1

		if [ $? -ne 0 ]; then
			RESULT=$(($RESULT + 1))
		fi
	else
		echo "Starting work on target $TARGET (2)" | tee -a $LOGFILE
		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION update" >> $LOGFILE
		make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION update >> $LOGFILE 2>&1
		echo -e "\n\n\nmake GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION clean" >> $LOGFILE
		make GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION clean >> $LOGFILE 2>&1
		echo -e "\n\n\nmake $DEBUG GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j$CPU_CNT" >> $LOGFILE
		make $DEBUG GLUON_TARGET=$TARGET GLUON_BRANCH=stable GLUON_RELEASE=$VERSION -j$CPU_CNT >> $LOGFILE 2>&1

		if [ $? -ne 0 ]; then
			RESULT=$(($RESULT + 1))
		fi
	fi
	echo "   Overall  error/s: $RESULT" | tee -a $LOGFILE
	echo -e "\n\n\n============================================================\n\n" >> $LOGFILE
done

if [ $RESULT -ne 0 ]; then
	echo "Compilation FAILED, see build.log         $RESULT error/s" | tee -a $LOGFILE
	cd $PATH_GLUON/site
	exit 1
else
	echo "Compilation complete, creating manifest(s)" | tee -a $LOGFILE

	echo $VERSION > $PATH_GLUON/output/images/sysupgrade/.version.txt

	echo -e "make GLUON_BRANCH=nightly GLUON_RELEASE=$VERSION manifest" >> $LOGFILE
	make GLUON_BRANCH=nightly GLUON_RELEASE=$VERSION manifest >> $LOGFILE 2>&1
	cp $PATH_GLUON/output/images/sysupgrade/nightly.manifest $PATH_GLUON/output/images/sysupgrade/.template.manifest
	echo -e "\n\n\n============================================================\n\n" >> $LOGFILE

	if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
	then
		echo -e "make GLUON_BRANCH=beta GLUON_RELEASE=$VERSION manifest" >> $LOGFILE
		make GLUON_BRANCH=beta GLUON_RELEASE=$VERSION manifest >> $LOGFILE 2>&1
		cp $PATH_GLUON/output/images/sysupgrade/beta.manifest $PATH_GLUON/output/images/sysupgrade/.template.manifest
		echo -e "\n\n\n============================================================\n\n" >> $LOGFILE
	fi

	if [[ "$BRANCH" == "stable" ]]
	then
		echo -e "make GLUON_BRANCH=stable GLUON_RELEASE=$VERSION manifest" >> $LOGFILE
		make GLUON_BRANCH=stable GLUON_RELEASE=$VERSION manifest >> $LOGFILE 2>&1
		echo -e "\n\n\n============================================================\n\n" >> $LOGFILE
	fi

	echo "Manifest creation complete, signing manifest" | tee -a $LOGFILE

	echo -e "$PATH_GLUON/contrib/sign.sh $FILE_SECRET $PATH_GLUON/output/images/sysupgrade/nightly.manifest" >> $LOGFILE
	$PATH_GLUON/contrib/sign.sh $FILE_SECRET $PATH_GLUON/output/images/sysupgrade/nightly.manifest >> $LOGFILE 2>&1

	if [[ "$BRANCH" == "beta" ]] || [[ "$BRANCH" == "stable" ]]
	then
		echo -e "$PATH_GLUON/contrib/sign.sh $FILE_SECRET $PATH_GLUON/output/images/sysupgrade/beta.manifest" >> $LOGFILE
		$PATH_GLUON/contrib/sign.sh $FILE_SECRET $PATH_GLUON/output/images/sysupgrade/beta.manifest >> $LOGFILE 2>&1
	fi

	if [[ "$BRANCH" == "stable" ]]
	then
		echo -e "$PATH_GLUON/contrib/sign.sh $FILE_SECRET $PATH_GLUON/output/images/sysupgrade/stable.manifest" >> $LOGFILE
		$PATH_GLUON/contrib/sign.sh $FILE_SECRET $PATH_GLUON/output/images/sysupgrade/stable.manifest >> $LOGFILE 2>&1
	fi

	echo -e "--- md5 erzeugen ---" >> $LOGFILE
	cd $PATH_GLUON/output/images/factory
	md5sum gluon* > md5.txt

	cd $PATH_GLUON/output/images/sysupgrade
	md5sum gluon* > md5.txt

	#back to gluon path
	cd $PATH_GLUON

	date >> $LOGFILE
	echo "Done :)         $RESULT error/s"| tee -a $LOGFILE

	#copying log files to output
	cp $LOGFILE $PATH_GLUON/output/images/.build.txt
	cp $PATH_LOG/pull.log $PATH_GLUON/output/images/.pull.txt
fi

cd  $PATH_GLUON/site
exit 0
