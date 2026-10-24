#!/usr/bin/env bash
# Push new media from the Mac to the server. Run ONLY on the home network (zero ISP quota).
set -euo pipefail
SRC="$HOME/Documents/Media/"
DEST="pve:/mnt/olinda/Media/"

rsync -rtvh --progress --partial --remove-source-files \
  --backup --backup-dir="/mnt/olinda/Media/.replaced/$(date +%F)" \
  --exclude='.DS_Store' --exclude='._*' \
  "$SRC" "$DEST"

find "$HOME/Documents/Media" -mindepth 2 -name '.DS_Store' -delete
find "$HOME/Documents/Media" -mindepth 2 -type d -empty -delete
echo "Done. Anything left in ~/Documents/Media did not transfer - check the output above."
