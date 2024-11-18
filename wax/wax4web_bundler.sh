#!/usr/bin/env bash

rm -rf ../wax4web/wax4web.tar ../wax4web/wax4web.tar.zip ../wax4web/wax4web_tar_zip
tar -cvf ../wax4web/wax4web.tar wax4web_entry.sh wax.sh str1pper.sh bootstrap sh1mmer_legacy sh1mmer_bw payloads firmware lib/wax_common.sh lib/shflags lib/bin/i386/cgpt --owner=0 --group=0
cd ../wax4web
mkdir -p wax4web_tar_zip
zip wax4web.tar.zip wax4web.tar
split -da1 --additional-suffix=.bin -b 24MiB wax4web.tar.zip wax4web_tar_zip/
rm wax4web.tar wax4web.tar.zip
