#!/usr/bin/env sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Activate
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./lungo.png
# @raycast.packageName Lungo

# Documentation:
# @raycast.author Michael Barrett
# @raycast.authorURL https://mdb.sh
# @raycast.description Deactivate Lungo
# @raycast.argument1 { "type": "text", "placeholder": "hours", "optional": true, "percentEncoded": true }
# @raycast.argument2 { "type": "text", "placeholder": "minutes", "optional": true, "percentEncoded": true }

function get_time_text() {
	local value=$1
	local singular=$2
	local plural=$3

	if [ "$value" -eq 1 ]; then
		echo "$value $singular"
	else
		echo "$value $plural"
	fi
}

open --background "lungo:activate?hours=$1&minutes=$2"

if [ -z "$1" ] && [ -z "$2" ]; then
	echo "Lungo Activated"
elif [ -n "$1" ] && [ -z "$2" ]; then
	echo "Lungo activated for $(get_time_text $1 "hour" "hours")"
elif [ -z "$1" ] && [ -n "$2" ]; then
	echo "Lungo activated for $(get_time_text $2 "minute" "minutes")"
else
	echo "Lungo activated for $(get_time_text $1 "hour" "hours") and $(get_time_text $2 "minute" "minutes")"
fi
