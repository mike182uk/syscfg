#!/usr/bin/env sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Deactivate
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./lungo.png
# @raycast.packageName Lungo

# Documentation:
# @raycast.author Michael Barrett
# @raycast.authorURL https://mdb.sh
# @raycast.description Deactivate Lungo

open --background lungo:deactivate

echo 'Lungo Deactivated'
