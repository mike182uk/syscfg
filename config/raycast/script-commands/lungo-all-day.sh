#!/usr/bin/env sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Activate All Day
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./lungo.png
# @raycast.packageName Lungo

# Documentation:
# @raycast.author Michael Barrett
# @raycast.authorURL https://mdb.sh
# @raycast.description Activate Lungo for the day

open --background "lungo:activate?hours=8"

echo 'Lungo activated for 8 hours'
