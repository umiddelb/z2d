#!/bin/sh

. config.sh


c_locale () {
	echo "$1"
	for ((i = 1; i <= $#; i++)); do
		if [$i = 1]; then
			echo "$1" "${!i}"
		else
			echo "$i" "${!i}"
		fi
	done
	for s in $@; do
		echo "$s"
	done
}

c_locale $LOCALES

