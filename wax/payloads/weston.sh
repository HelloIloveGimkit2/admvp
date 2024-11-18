#!/bin/bash

if ! [ -f /usr/local/bin/weston ]; then
	echo "weston not found"
	exit 1
fi

export PATH="$PATH:/usr/local/bin"
export LD_LIBRARY_PATH="/lib64:/usr/lib64:/usr/local/lib64"
pkill -9 frecon &
sleep 0.5 &
XDG_RUNTIME_DIR=/run MESA_LOADER_DRIVER_OVERRIDE=i965 /usr/local/bin/weston -B drm-backend.so &
disown
