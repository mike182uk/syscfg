#!/usr/bin/env sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Desk
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ./ha.png
# @raycast.packageName Home Assistant

# Documentation:
# @raycast.author Michael Barrett
# @raycast.authorURL https://mdb.sh
# @raycast.description Toggle Desk

source ./.env

curl -X POST $HA_URL/api/webhook/$HA_WEBHOOK_ID_TOGGLE_DESK

echo 'Automation Triggered'
