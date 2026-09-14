#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2023-2024 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
FDEVICE="lancelot"

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep \"$FDEVICE\")
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep \"$FDEVICE\")
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
        export ALLOW_MISSING_DEPENDENCIES=true
        export FOX_ENABLE_APP_MANAGER=1
	export TARGET_DEVICE_ALT="lancelot"
	export FOX_TARGET_DEVICES="lancelot,galahad,shiva"
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_BASH_TO_SYSTEM_BIN=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_USE_LZ4_BINARY=1
	export FOX_USE_ZSTD_BINARY=1
	# No vanilla build and no addon removal: we want all of them.
	# These must be set to 0 explicitly. Simply dropping the lines is not
	# enough, because a variable already exported in the build shell survives
	# a re-source of envsetup.sh.
	# (FOX_USE_SPECIFIC_MAGISK_ZIP pointed at a zip that does not exist here;
	#  clearing it falls back to the Magisk.zip shipped in the tree.)
	export FOX_VANILLA_BUILD=0
	export FOX_DELETE_INITD_ADDON=0
	export FOX_USE_SPECIFIC_MAGISK_ZIP=
	export FOX_USE_BUSYBOX_BINARY=1
        export OF_MAINTAINER="angelpro09"
	# BLKROSET fails on the raw eMMC (/dev/block/mmcblk0). It is harmless,
	# so log it as info instead of as an error
	export OF_LOOP_DEVICE_ERRORS_TO_LOG=1

	# FRP erase addon
	export OF_ENABLE_FRP_ADDON=1
	# lptools: logical partition (super) management, useful on this device
	export OF_ENABLE_LPTOOLS=1

	# make all builds dynamic
	export FOX_USE_DYNAMIC_PARTITIONS=1
	export FOX_VARIANT="HWe"
else
	if [ -z "$FOX_BUILD_DEVICE" -a -z "$BASH_SOURCE" ]; then
		echo "I: This script requires bash. Not processing the $FDEVICE $(basename $0)"
	fi
fi
#
