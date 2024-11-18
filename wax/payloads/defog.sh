#!/bin/bash

if flashrom --wp-disable; then
	/usr/share/vboot/bin/set_gbb_flags.sh 0x8090
	crossystem block_devmode=0
	vpd -i RW_VPD block_devmode=0
	echo "GBB flags set. Devmode should now be unblocked"
else
	echo "Could not disable software WP"
	exit 1
fi
