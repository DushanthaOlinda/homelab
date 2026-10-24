#!/bin/bash
# Build ordered Jellyfin playlists from a sort-title prefix (run on the gateway).
# Usage: set sort titles like "MCU 01".."MCU 27" first, then: mk "MCU" "MCU Watch Order"
source /etc/homepage.env
J=http://192.168.1.203:8096
H="Authorization: MediaBrowser Token=\"$HOMEPAGE_VAR_JELLYFIN_KEY\""
USERID=$(curl -s -H "$H" "$J/Users" | jq -r '.[0].Id')
mk() {
  ids=$(curl -s -H "$H" "$J/Items?IncludeItemTypes=Movie&Recursive=true&SortBy=SortName&NameStartsWith=$1" | jq -c '[.Items[].Id]')
  n=$(echo "$ids" | jq length); echo "$2: $n movies"
  [ "$n" -gt 0 ] || return
  curl -s -X POST -H "$H" -H 'Content-Type: application/json' "$J/Playlists" \
    -d "{\"Name\":\"$2\",\"Ids\":$ids,\"UserId\":\"$USERID\",\"MediaType\":\"Video\"}"; echo
}
