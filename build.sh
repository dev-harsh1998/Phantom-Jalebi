#!/bin/bash
rm .version
# Bash Color
green='\033[01;32m'
red='\033[01;31m'
cyan='\033[01;36m'
blue='\033[01;34m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
DEFCONFIG="cyanogenmod_jalebi_defconfig"
KERNEL="zImage"

#Hyper Kernel Details
BASE_VER="Phantom"
VER="-v1-$(date +"%Y-%m-%d"-%H%M)-"
Hyper_VER="$BASE_VER$VER$TC"

# Vars
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=dev-harsh1998
export KBUILD_BUILD_HOST=PhAnToM-Server1

# Paths
KERNEL_DIR=`pwd`
RESOURCE_DIR="/home/android/kernel/Phantom-Jalebi"
ANYKERNEL_DIR="$RESOURCE_DIR/AnyKernel2"
TOOLCHAIN_DIR="/home/android/kernel/tc"
REPACK_DIR="$ANYKERNEL_DIR"
#PATCH_DIR="$ANYKERNEL_DIR/patch"
#MODULES_DIR="$ANYKERNEL_DIR/modules"
ZIP_MOVE="$RESOURCE_DIR/kernel_out"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm/boot"

# Functions
function make_kernel {
		make $DEFCONFIG $THREAD
		make $KERNEL $THREAD
                make dtbs $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/tools/zImage
}

#function make_modules {
#		cd $KERNEL_DIR
#		make modules $THREAD
#		find $KERNEL_DIR -name '*.ko' -exec cp {} $MODULES_DIR/ \;
#		cd $MODULES_DIR
#        $STRIP --strip-unneeded *.ko
#        cd $KERNEL_DIR
#}

function make_dtb {
		$KERNEL_DIR/dtbToolCM -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
		cp -vr $KERNEL_DIR/arch/arm/boot/dt.img $REPACK_DIR/tools/dt.img
}

function make_zip {
		cd $REPACK_DIR
                zip -r `echo $Hyper_VER$TC`.zip *
		mv  `echo $Hyper_VER$TC`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

DATE_START=$(date +"%s")

# TC tasks
export CROSS_COMPILE=$TOOLCHAIN_DIR/hj123/bin/arm-eabi-
export LD_LIBRARY_PATH=$TOOLCHAIN_DIR/hj123/lib/
#STRIP=$TOOLCHAIN_DIR/uber-4.9/bin/aarch64-linux-android-strip
TC="UB"
#rm -rf $MODULES_DIR/*
rm -rf $ZIP_MOVE/*
rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
cd $ANYKERNEL_DIR/tools
rm -rf zImage
rm -rf dt.img
cd $KERNEL_DIR

# Make
make_kernel
make_dtb
#make_modules
make_zip

echo -e "${green}"
echo $Hyper_VER$TC.zip
echo "------------------------------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo " "
cd $ZIP_MOVE
ls
