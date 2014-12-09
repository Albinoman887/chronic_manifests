#!/bin/bash

#Config options
export SRC_ROOT=/home/albinoman887/cm-12

#######################################################################################

export DEVICE="$1"
export CURDATE=`date "+%m.%d.%Y"`
export PATH=~/bin:$PATH
export USE_CCACHE=1


function DoBuild()
{
cd $SRC_ROOT
. build/envsetup.sh
lunch cm_$DEVICE-userdebug
make -j13 bacon
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

#print build config
echo
echo "Set DEVICE to: $DEVICE"
echo

#Get time
time_start=$(date +%s.%N)

#Build
DoBuild

#Print total build time
time_end=$(date +%s.%N)
echo -e "${BLDYLW}Total time elapsed: ${TCTCLR}${TXTGRN}$(echo "($time_end - $time_start) / 60"|bc ) ${TXTYLW}minutes${TXTGRN} ($(echo "$time_end - $time_start"|bc ) ${TXTYLW}seconds) ${TXTCLR}"
