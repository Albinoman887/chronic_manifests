#!/bin/bash

#Config options
export BUILD_TYPE=nightly
export SRC_ROOT=/home/albinoman887/cm-11
export WEB_ROOT=/var/www/html
export MIRROR_ROOT=albinoman@www.chronic-buildbox.com:/var/www/html
export MEGA_ROOT=/Root/html

#######################################################################################

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
cp -r cm-11*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/
scp -p cm-11*.zip $MIRROR_ROOT/$DEVICE/$BUILD_TYPE/
megasync --reload -l $WEB_ROOT/$DEVICE/$BUILD_TYPE -r $MEGA_ROOT/$DEVICE/$BUILD_TYPE
}

#######################################################################################

#cleanup and sync
cd $SRC_ROOT
make clobber
repo sync

#Get time
time_start=$(date +%s.%N)

#klte
#DEVICE=klte
#DoBuild
#SetupDownloads

#kltedv
DEVICE=kltedv
DoBuild
SetupDownloads

#kltespr
#DEVICE=kltespr
#DoBuild
#SetupDownloads

#klteusc
#DEVICE=klteusc
#DoBuild
#SetupDownloads

#kltevzw
#DEVICE=kltevzw
#DoBuild
#SetupDownloads


#cleanup
cd $SRC_ROOT
make clobber

#echo total build time
time_end=$(date +%s.%N)
echo -e "${BLDYLW}Total time elapsed: ${TCTCLR}${TXTGRN}$(echo "($time_end - $time_start) / 60"|bc ) ${TXTYLW}minutes${TXTGRN} ($(echo "$time_end - $time_start"|bc ) ${TXTYLW}seconds) ${TXTCLR}"
