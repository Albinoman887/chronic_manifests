#!/bin/bash

#Config options
export PACKAGE_NAME=cm-13
export SRC_ROOT=/home/albinoman887/android/$PACKAGE_NAME
export TMP_UPLOAD=/home/albinoman887/upload
export REMOTE_URL=albinoman887@23.94.12.54
export HOME_URL=albinoman887@filetto-server.duckdns.org
export WEB_ROOT=/var/www/html

#######################################################################################

export DEVICE="$1"
export BUILD_TYPE="$2"
export CURDATE=`date "+%m.%d.%Y"`
export PATH=~/bin:$PATH
export USE_CCACHE=1
export CCACHE_DIR="/home/albinoman887/.ccache"
export ANDROID_CCACHE_DIR="/home/albinoman887/.ccache"

function DoBuild()
{
cd $SRC_ROOT
. build/envsetup.sh
lunch cm_$DEVICE-userdebug
echo "Device set to $DEVICE and BUILD TYPE set to $BUILD_TYPE"
mka bacon
}

function SetupDownloads()
{
cd $SRC_ROOT/out/target/product/$DEVICE/
cp -r $PACKAGE_NAME*.zip $TMP_UPLOAD/
cd $TMP_UPLOAD
\
#Cop to main
scp -p $PACKAGE_NAME*.zip $REMOTE_URL:$TMP_UPLOAD/
ssh -t $REMOTE_URL "cd $TMP_UPLOAD ; cp -r $PACKAGE_NAME*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/ ; rm -r $PACKAGE_NAME*.zip"

rm -r $PACKAGE_NAME*.zip
cd $SRC_ROOT
}

#######################################################################################

#Sync
repo forall -c 'git reset --hard'
repo sync --force-sync

#Get time
time_start=$(date +%s.%N)


#Build
BUILD_TYPE=nightly

DEVICE=klte
DoBuild
SetupDownloads

DEVICE=kltespr
DoBuild
SetupDownloads

DEVICE=klteusc
DoBuild
SetupDownloads

DEVICE=kltedv
DoBuild
SetupDownloads

#cleanup
cd $SRC_ROOT
make clobber


#Print total build time
time_end=$(date +%s.%N)
echo -e "${BLDYLW}Total time elapsed: ${TCTCLR}${TXTGRN}$(echo "($time_end - $time_start) / 60"|bc ) ${TXTYLW}minutes${TXTGRN} ($(echo "$time_end - $time_start"|bc ) ${TXTYLW}seconds) ${TXTCLR}"


