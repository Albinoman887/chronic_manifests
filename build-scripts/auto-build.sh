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
cp -r $PACKAGE_NAME*.zip $TMP_UPLOAD/
cd $TMP_UPLOAD

#Copy to home
if [ "$BUILD_TYPE" = "dev" ]; then
  if [ "$DEVICE" = "shamu" ]; then
echo
echo "Device set to $DEVICE and BUILD TYPE set to $BUILD_TYPE"
echo "Copying to home server..."
echo

scp -p $PACKAGE_NAME*.zip $HOME_URL:$TMP_UPLOAD/
ssh -t $HOME_URL "cd $TMP_UPLOAD ; cp -r $PACKAGE_NAME*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/ ; rm -r $PACKAGE_NAME*.zip"
  fi
fi

if [ "$BUILD_TYPE" = "dev" ]; then
  if [ "$DEVICE" = "klte" ]; then
echo
echo "Device set to $DEVICE and BUILD TYPE set to $BUILD_TYPE"
echo "Copying to home server..."
echo

scp -p $PACKAGE_NAME*.zip $HOME_URL:$TMP_UPLOAD/
ssh -t $HOME_URL "cd $TMP_UPLOAD ; cp -r $PACKAGE_NAME*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/ ; rm -r $PACKAGE_NAME*.zip"
  fi
fi

if [ "$BUILD_TYPE" = "dev" ]; then
  if [ "$DEVICE" = "m8" ]; then
echo
echo "Device set to $DEVICE and BUILD TYPE set to $BUILD_TYPE"
echo "Copying to home server..."
echo

scp -p $PACKAGE_NAME*.zip $HOME_URL:$TMP_UPLOAD/
ssh -t $HOME_URL "cd $TMP_UPLOAD ; cp -r $PACKAGE_NAME*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/ ; rm -r $PACKAGE_NAME*.zip"
  fi
fi


#Cop to main
scp -p $PACKAGE_NAME*.zip $REMOTE_URL:$TMP_UPLOAD/
ssh -t $REMOTE_URL "cd $TMP_UPLOAD ; cp -r $PACKAGE_NAME*.zip $WEB_ROOT/$DEVICE/$BUILD_TYPE/ ; rm -r $PACKAGE_NAME*.zip"

rm -r $PACKAGE_NAME*.zip
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

if [ "$BUILD_TYPE" = "dev" ]; then
  if [ "$DEVICE" = "shamu" ]; then
echo
echo "Device is $DEVICE and build type is $BUILD_TYPE, will be copied to home server"
echo
  fi
fi

if [ "$BUILD_TYPE" = "dev" ]; then
  if [ "$DEVICE" = "klte" ]; then
echo
echo "Device is $DEVICE and build type is $BUILD_TYPE, will be copied to home server"
echo
  fi
fi

if [ "$BUILD_TYPE" = "dev" ]; then
  if [ "$DEVICE" = "m8" ]; then
echo
echo "Device is $DEVICE and build type is $BUILD_TYPE, will be copied to home server"
echo
  fi
fi


#Get time
time_start=$(date +%s.%N)

#Build
DoBuild

#Copy builds
SetupDownloads

#Print total build time
time_end=$(date +%s.%N)
echo -e "${BLDYLW}Total time elapsed: ${TCTCLR}${TXTGRN}$(echo "($time_end - $time_start) / 60"|bc ) ${TXTYLW}minutes${TXTGRN} ($(echo "$time_end - $time_start"|bc ) ${TXTYLW}seconds) ${TXTCLR}"


