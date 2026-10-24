#!/bin/bash
# Builds /media/wd-tv: links every show in "TV series" except The Last Ship,
# plus a renamed view of The Last Ship (episode numbers taken from folder names).
set -euo pipefail
SRC="/media/wd/TV series"
DST="/media/wd-tv"
SHIP_SRC="$SRC/the last ship"
SHIP_DST="$DST/The Last Ship (2014)"
re='[Ss]0?([0-9]{1,2})[-_. ]?[Ee]([0-9]{1,2})'

# Safety: never build from an empty/unmounted drive
[ -d "$SRC" ] && [ -n "$(ls -A "$SRC")" ] || { echo "SRC empty or unmounted - aborting"; exit 1; }

rm -rf "$DST"; mkdir -p "$DST"

# 1. Every other show, linked as-is
for d in "$SRC"/*/; do
  name=$(basename "$d")
  [ "$name" = "the last ship" ] && continue
  ln -s "${d%/}" "$DST/$name"
done

# 2. The Last Ship, renamed from folder/file names
find "$SHIP_SRC" -type f \( -iname '*.mkv' -o -iname '*.mp4' -o -iname '*.avi' \) | while read -r f; do
  rel="${f#$SHIP_SRC/}"
  if [[ $rel =~ $re ]]; then
    s=$(printf '%02d' "$((10#${BASH_REMATCH[1]}))")
    e=$(printf '%02d' "$((10#${BASH_REMATCH[2]}))")
    ext="${f##*.}"; ext="${ext,,}"
    mkdir -p "$SHIP_DST/Season $s"
    link="$SHIP_DST/Season $s/The Last Ship S${s}E${e}.$ext"
    if [ -e "$link" ]; then echo "DUPLICATE: $rel"; continue; fi
    ln -s "$f" "$link"
  else
    echo "NO EPISODE NUMBER: $rel"
  fi
done

echo "--- The Last Ship view ---"
for s in "$SHIP_DST"/*/; do echo "$(basename "$s"): $(ls "$s" | wc -l) episodes"; done
echo "--- Other shows linked: $(find "$DST" -maxdepth 1 -type l | wc -l)"
