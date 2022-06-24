#!/bin/bash
if [[ "$(/usr/bin/ibus engine)" != "xkb:us::eng" ]]; then
	/usr/bin/ibus engine xkb:us::eng
else
	if [[ "$(/usr/bin/cat /tmp/current_ime || echo 1)" == "1" ]]; then
		/usr/bin/ibus engine hangul
	else
		/usr/bin/ibus engine mozc-jp
	fi
fi
