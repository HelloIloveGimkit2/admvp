#!/bin/bash

echo "Sourcing exploit files..."
sleep 1
echo "Starting bootwrite..."
crossystem battery_cutoff_request=1 >/dev/null 2>&1 || :
crossystem battery_cutoff_request=1 >/dev/null 2>&1 || :
echo "Think about what you just did."
sleep 2
echo "You downloaded a random file from the internet which now has full root access to your chromebook"
sleep 2
echo "Despite it being open source, you didn't check the payload to see what it would actually do" # Unless you're reading this comment, in which case you're a really cool person! Thanks for taking the time to go into the source code
sleep 2
echo "And then you pressed a random sketchy menu option"
sleep 4
echo ""
echo "lol"
sleep 2
reboot -f
tail -f /dev/null
