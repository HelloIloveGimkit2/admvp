#!/usr/bin/env bash

set -e

if ! [ -d libapps ]; then
	git clone -n https://chromium.googlesource.com/apps/libapps
	cd libapps
	git checkout d282bc164a38c1b3ff25cf0e64c640a506c749ea
	git apply ../hterm.patch
else
	cd libapps
fi
hterm/bin/mkdist
cp hterm/dist/js/hterm_all.js ..
uglifyjs ../hterm_all.js > ../hterm_all.min.js
