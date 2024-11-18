#!/usr/bin/env bash

# note: on debian, libftdi1-dev is mutually incompatible with itself for different dpkg architectures, you will need to reinstall the one for the arch you want to build here
echo "good luck..."

set -e

CROSS=
STRIP=strip
CROSSFILE=
if ! [ -z "$1" ]; then
	CROSS=("CC=${1}-gcc" "STRIP=${1}-strip" "AR=${1}-ar" "RANLIB=${1}-ranlib" "PKG_CONFIG=${1}-pkg-config")
	STRIP="${1}-strip"
	CROSSFILE="$(mktemp)"
	(
	echo "[binaries]"
	echo "c = '${1}-gcc'"
	echo "cpp = '${1}-g++'"
	echo "ar = '${1}-ar'"
	echo "strip = '${1}-strip'"
	echo "pkgconfig = '${1}-pkg-config'"
	echo "pkg-config = '${1}-pkg-config'"
	echo ""
	echo "[host_machine]"
	echo "system = '$(echo "$1" | cut -d- -f2)'"
	echo "cpu_family = '$(echo "$1" | cut -d- -f1)'"
	echo "cpu = '$(echo "$1" | cut -d- -f1)'"
	echo "endian = 'little'"
	) >"$CROSSFILE"
	CROSSFILE="--cross-file=$CROSSFILE"
fi

rm -rf lib
mkdir lib
LIBDIR="$(realpath lib)"

if ! [ -d pciutils ]; then
	git clone -n https://github.com/pciutils/pciutils
	cd pciutils
	git checkout v3.11.1
else
	cd pciutils
	make clean
fi

if [ -z "$1" ]; then
	make install-lib DESTDIR="$LIBDIR" PREFIX=
else
	make install-lib DESTDIR="$LIBDIR" PREFIX= CROSS_COMPILE="$1"- HOST="$1"
fi
cd ..

if ! [ -d systemd ]; then
	git clone -n https://github.com/systemd/systemd
	cd systemd
	git checkout v255
else
	cd systemd
	rm -rf build
fi

meson setup -Dbuildtype=release -Dstatic-libudev=true -Dprefix=/ -Dc_args="-Wno-error=format-overflow" "$CROSSFILE" build
ninja -C build libudev.a devel
cp build/libudev.a "$LIBDIR/lib"
mkdir -p "$LIBDIR/lib/pkgconfig"
cp build/src/libudev/libudev.pc "$LIBDIR/lib/pkgconfig"
[ ! -f "$CROSSFILE" ] || rm "$CROSSFILE"
cd ..

if ! [ -d flashrom-repo ]; then
	git clone -n https://chromium.googlesource.com/chromiumos/third_party/flashrom flashrom-repo
	cd flashrom-repo
	git checkout 24513f43e17a29731b13bfe7b2f46969c45b25e0
	git apply ../flashrom.patch
else
	cd flashrom-repo
	#rm -rf build
	make clean
fi

export PKG_CONFIG_PATH="$LIBDIR/lib/pkgconfig"

# fuck this shit, i hate meson
#export LIBRARY_PATH="$LIBDIR/lib"
#meson setup -Dbuildtype=release -Dprefer_static=true -Dtests=disabled -Ddefault_programmer_name=internal -Dwerror=false -Dc_args="-I$LIBDIR/include" -Dc_link_args="-static -lcap -lz" "$CROSSFILE" build
#ninja -C build flashrom
#"$STRIP" -s build/flashrom

make strip CONFIG_STATIC=yes CONFIG_DEFAULT_PROGRAMMER_NAME=internal CFLAGS="-I$LIBDIR/include" LDFLAGS="-L$LIBDIR/lib" EXTRA_LIBS="-lcap -lz" "${CROSS[@]:-ASDFGHJKLQWER=stfu}"
cp flashrom ..
