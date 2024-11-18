#!/bin/bash

echo "Wings - SH1MMER Wifi Payload"
echo "Will only work with Open and password-only networks, not EAP networks. Leave password blank for Open networks."
echo "Made by r58Playz"
read -rep "network > " network
read -rep "password> " password
/usr/local/bin/python3 /usr/local/autotest/client/cros/scripts/wifi connect "$network" "$password"
