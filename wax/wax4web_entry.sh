#!/bin/bash
# this script should have pid 1

SHARED_FS_MNT="$1"

WAX_OPTS=()
[ -f "$SHARED_FS_MNT"/opt.legacy ] && WAX_OPTS+=("-p legacy")
[ -f "$SHARED_FS_MNT"/opt.payloads ] || WAX_OPTS+=("-e ''")
[ -f "$SHARED_FS_MNT"/opt.fast ] && WAX_OPTS+=("--fast")
[ -f "$SHARED_FS_MNT"/opt.debug ] && WAX_OPTS+=("--debug")

if time ./wax.sh -i /dev/sda --finalsizefile "$SHARED_FS_MNT"/finalsize ${WAX_OPTS[@]}; then
	echo "Your shim has finished building"
else
	echo -e "An error occured\033[?25h"
	stty echo
	bash
fi

poweroff -f
tail -f /dev/null
