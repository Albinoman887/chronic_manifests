#!/bin/bash

#Config options
export SRC_ROOT=/home/albinoman887/cm-12
export TMP_UPLOAD=/home/albinoman887/upload
export REMOTE_URL=www.chronic-buildbox.com
export MIRROR_URL=mirror.chronic-buildbox.com
export MEGA_ROOT=/Root/html
export WEB_ROOT=/var/www/html

#######################################################################################

export DEVICE="$1"
export BUILD_TYPE="$2"
export CURDATE=`date "+%m.%d.%Y"`
export PATH=~/bin:$PATH
export USE_CCACHE=1


function DoBuild()
{
cd $SRC_ROOT
. build/envsetup.sh
lunch cm_$DEVICE-userdebug
mka bacon
}

function SetupDownloads()
{
cd $SRC_ROOT/out/target/product/$DEVICE/
cp -r cm-12*.zip $TMP_UPLOAD/
cd $TMP_UPLOAD
cp -r cm-12*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/

#Cop to main
#scp -p cm-12*.zip $REMOTE_URL:$TMP_UPLOAD/
#ssh -t $REMOTE_URL "cd $TMP_UPLOAD ; cp -r cm-12*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/ ; rm -r cm-12*.zip"

#Copy to mirror
#scp -p cm-12*.zip $MIRROR_URL:$TMP_UPLOAD/
#ssh -t $MIRROR_URL "cd $TMP_UPLOAD ; cp -r cm-12*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/ ; rm -r cm-12*.zip"

#rsync
rsync -azP --delete $WEB_ROOT/$DEVICE/$BUILD_TYPE/ $REMOTE_URL:$WEB_ROOT/$DEVICE/$BUILD_TYPE
rsync -azP --delete $WEB_ROOT/$DEVICE/$BUILD_TYPE/ $MIRROR_URL:$WEB_ROOT/$DEVICE/$BUILD_TYPE
#if [ "$BUILD_TYPE" != "dev" ]; then
#megasync -l $WEB_ROOT/$DEVICE/$BUILD_TYPE -r $MEGA_ROOT/$DEVICE/$BUILD_TYPE
#fi
rm -r cm-12*.zip
cd $SRC_ROOT
}

#######################################################################################

#Set device
if [ "$1" = "" ]; then
clear
echo 
echo "No device set via cmdline, enter which device to build: "
echo
read DEVICE
fi

#Set build type
if [ "$2" = "" ]; then
clear
echo
echo "No build type set via cmdline, select build type (nightly/release/dev): "
echo
read BUILD_TYPE
fi

#print build config
echo
echo "Set DEVICE to: $DEVICE"
echo "Set BUILD TYPE to: $BUILD_TYPE"
echo

#Get time
time_start=$(date +%s.%N)

#Build
DoBuild

#Print total build time
time_end=$(date +%s.%N)
echo -e "${BLDYLW}Total time elapsed: ${TCTCLR}${TXTGRN}$(echo "($time_end - $time_start) / 60"|bc ) ${TXTYLW}minutes${TXTGRN} ($(echo "$time_end - $time_start"|bc ) ${TXTYLW}seconds) ${TXTCLR}"

#Copy builds
SetupDownloads
