#!/bin/bash

set -e

COLOR_RESET="\033[0m"
COLOR_RED_B="\033[1;31m"
COLOR_GREEN_B="\033[1;32m"

wp_disable() {
	while :; do
		if flashrom --wp-disable; then
			echo -e "${COLOR_GREEN_B}Success. Note that some devices may need to reboot before the chip is fully writable.${COLOR_RESET}"
			return 0
		fi
		echo -e "${COLOR_RED_B}Press CTRL+C to cancel.${COLOR_RESET}"
		sleep 1
	done
}

trap 'exit 1' INT

wp_disable
