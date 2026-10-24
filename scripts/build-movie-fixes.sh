#!/bin/bash
# Run AFTER build-wd-views.sh. Replaces numbered movie entries in the movies
# view with clean "Title (Year)" folders + a movie.nfo sort title (watch order).
set -euo pipefail
SRC=/media/wd; VIEW=/media/wd-movies; LIST=/etc/media-views/movie-fixes.list
[ -n "$(ls -A "$SRC" 2>/dev/null)" ] || { echo "WD not mounted - aborting"; exit 1; }
[ -d "$VIEW" ] || { echo "No movies view - run build-wd-views.sh first"; exit 1; }

grep -vE '^\s*(#|$)' "$LIST" | while IFS='|' read -r key title sortkey; do
  [ -n "${sortkey:-}" ] || sortkey="${title% (*}"
  group=$(dirname "$key"); num=$(basename "$key")
  match=$(compgen -G "$SRC/$group/${num}[ ._]*" | head -1 || true)
  [ -n "$match" ] || { echo "NOT FOUND: $key"; continue; }

  # Folder per movie -> take its largest video file; loose file -> use it
  if [ -d "$match" ]; then
    file=$(find "$match" -maxdepth 1 -type f \( -iname '*.mkv' -o -iname '*.mp4' -o -iname '*.avi' \) -printf '%s\t%p\n' | sort -rn | head -1 | cut -f2-)
  else
    file="$match"
  fi
  [ -n "$file" ] || { echo "NO VIDEO: $key"; continue; }

  # If the group is a single symlink in the view (e.g. DC/DC Animated Series),
  # turn it into a real folder of links so individual entries can be swapped
  vgroup="$VIEW/$group"
  if [ -L "$vgroup" ]; then
    target=$(readlink "$vgroup"); rm "$vgroup"; mkdir -p "$vgroup"
    for c in "$target"/*; do ln -s "$c" "$vgroup/"; done
  fi

  # Remove the old numbered entry (a link, or a view folder of links)
  old="$vgroup/$(basename "$match")"
  if [ -L "$old" ]; then rm "$old"
  elif [ -d "$old" ] && [[ "$old" == "$VIEW"/* ]]; then rm -rf -- "$old"; fi

  # Clean entry: folder + video link + sort title
  dest="$vgroup/$title"; mkdir -p "$dest"
  ext="${file##*.}"; ln -sfn "$file" "$dest/$title.${ext,,}"
  printf '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n<movie>\n  <sorttitle>%s</sorttitle>\n</movie>\n' "$sortkey" > "$dest/movie.nfo"
  echo "OK   $title"
done
