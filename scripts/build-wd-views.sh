#!/bin/bash
# Builds Jellyfin symlink "views" of a read-only media archive (runs inside the Jellyfin CT).
#
# Problem: the archive is read-only and has TV shows nested inside movie folders,
# so Jellyfin's Movies library would scan episodes as movies.
# Solution: build two symlink trees on the container's own disk:
#   $MOV - everything in the archive except the listed shows
#   $TV  - only the listed shows, renamed to "Show Name (Year)"
#
# The show list is kept OUTSIDE the repo. See shows.list.example.
set -uo pipefail
shopt -s nullglob

SRC="${SRC:-/media/wd}"              # read-only archive mount
MOV="${MOV:-/media/wd-movies}"       # movies view (Jellyfin Movies library)
TV="${TV:-/media/wd-shows}"          # shows view (Jellyfin Shows library)
LIST="${LIST:-/etc/media-views/shows.list}"

# Safety: never rebuild from an empty/unmounted archive, or Jellyfin would drop the whole library
[ -n "$(ls -A "$SRC" 2>/dev/null)" ] || { echo "Archive not mounted at $SRC - views left untouched"; exit 1; }
[ -r "$LIST" ] || { echo "Show list not found: $LIST"; exit 1; }

# Top-level folders never linked into the movies view (Windows system folders by default)
EXCLUDE=('$RECYCLE.BIN' 'System Volume Information' 'found.*')
SHOWS=()

# List format:  path/in/archive|Show Name (Year)    or    !top-level-folder-to-exclude
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  if [[ "$line" == \!* ]]; then EXCLUDE+=("${line#!}"); else SHOWS+=("$line"); fi
done < "$LIST"

is_show()  { local e; for e in "${SHOWS[@]}"; do [[ "${e%%|*}" == "$1" ]] && return 0; done; return 1; }
has_show() { local e; for e in "${SHOWS[@]}"; do [[ "${e%%|*}" == "$1/"* ]] && return 0; done; return 1; }
excluded() { local p; for p in "${EXCLUDE[@]}"; do [[ "$1" == $p ]] && return 0; done; return 1; }

link_tree() {
  local rel="$1" dir child name crel
  dir="$SRC${rel:+/$rel}"
  for child in "$dir"/*; do
    name="${child##*/}"; crel="${rel:+$rel/}$name"
    if [[ -z "$rel" ]] && excluded "$name"; then continue; fi
    if is_show "$crel"; then continue; fi
    if [[ -d "$child" ]] && has_show "$crel"; then
      mkdir -p "$MOV/$crel"; link_tree "$crel"   # folder mixes shows and movies: descend
    else
      ln -s "$child" "$MOV/$crel"
    fi
  done
}

rm -rf "$MOV" "$TV"; mkdir -p "$MOV" "$TV"
for e in "${SHOWS[@]}"; do ln -s "$SRC/${e%%|*}" "$TV/${e#*|}"; done
link_tree ""
echo "Movies view: $(find "$MOV" -maxdepth 1 | wc -l) entries | Shows view: $(ls "$TV" | wc -l) shows"
