#!/usr/bin/env bash

set -e

CROSS=
STRIP=strip
if ! [ -z "$1" ]; then
	CROSS="CXX=${1}-g++"
	STRIP="${1}-strip"
fi
[ -f gptfdisk-1.0.10.tar.gz ] || wget 'https://netactuate.dl.sourceforge.net/project/gptfdisk/gptfdisk/1.0.10/gptfdisk-1.0.10.tar.gz'
rm -rf gptfdisk-1.0.10
echo "extracting archive..."
tar -xf gptfdisk-1.0.10.tar.gz
echo "done"
cd gptfdisk-1.0.10
patch -u -p0 -i ../sgdisk.patch
make sgdisk "${CROSS:-ASDFGHJKLQWER=stfu}"
"$STRIP" -s sgdisk
cp sgdisk ..
