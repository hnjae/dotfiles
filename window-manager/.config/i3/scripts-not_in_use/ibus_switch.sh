#!/bin/bash

# current_ime == 1: hangul
if [[ "$(/usr/bin/cat /tmp/current_ime || echo 1)" == "1" ]]; then
	echo 2 > /tmp/current_ime
	/usr/bin/ibus engine mozc-jp
else
	echo 1 > /tmp/current_ime
	/usr/bin/ibus engine hangul
fi
