#!/bin/bash

#Config options
export PACKAGE_NAME=cm-13
export SRC_ROOT=/home/albinoman887/android/cm-13
export TMP_UPLOAD=/home/albinoman887/upload
export REMOTE_URL=albinoman887@23.94.12.54
export HOME_URL=albinoman887@filetto-server.duckdns.org
export WEB_ROOT=/var/www/html

#######################################################################################

export BUILD_TYPE=nightly
export PATH=~/bin:$PATH
export USE_CCACHE=1
export CCACHE_DIR="/home/albinoman887/.ccache"
export ANDROID_CCACHE_DIR="/home/albinoman887/.ccache"

function DoBuild()
{
cd $SRC_ROOT
make clobber
. build/envsetup.sh
lunch cm_$DEVICE-userdebug
echo "Device set to $DEVICE and BUILD TYPE set to $BUILD_TYPE"
mka bacon
}

function SetupDownloads()
{
cd $SRC_ROOT/out/target/product/$DEVICE/
cp -r cm-13*.zip $TMP_UPLOAD/
cd $TMP_UPLOAD
\
#Cop to main
scp -p cm-13*.zip $REMOTE_URL:$TMP_UPLOAD/
ssh -t $REMOTE_URL "cd $TMP_UPLOAD ; cp -r cm-13*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/ ; rm -r cm-13*.zip"

rm -r cm-13*.zip
cd $SRC_ROOT
}

#######################################################################################

#Sync
cd $SRC_ROOT
repo forall -c 'git reset --hard'
repo sync --force-sync

#Build

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



