# 11 — Media views (Jellyfin, CT 103)

The WD archive is read-only NTFS, so nothing on it can be renamed. Instead,
symlink "views" inside CT 103 give Jellyfin clean names.

| View | Built by | Library |
|---|---|---|
| `/media/wd-movies` | `build-wd-views.sh` then `build-movie-fixes.sh` | Movies |
| `/media/wd-shows` | `build-wd-views.sh` (from `shows.list`) | Shows |
| `/media/wd-tv` | `build-tv-view.sh` | Shows |

Libraries: Movies = `wd-movies` + `/media/olinda/Movies`;
Shows = `wd-shows` + `wd-tv` + `/media/olinda/Shows`. Never the raw `/media/wd`.

- **Numbered franchise movies** (watch order like `03 Iron man 2008`) break
  matching. `movie-fixes.list` maps `group/number|Title (Year)`; the script swaps
  each entry for a clean folder + `movie.nfo`. Matching by number also handles
  release names with look-alike Unicode letters.
- **The Last Ship S3–S5** has numeric file names; `build-tv-view.sh` takes the
  episode number from the folder name instead.
- **Watch order** lives in playlists (*MCU Watch Order*, *DC Animated Movie
  Universe*), not sort titles: the A–Z filter uses sort titles.
- Image fetchers: TheMovieDb first; Embedded Image Extractor and Screen Grabber
  off (Pahe embeds its logo as cover art).

**Rebuild after changes:** `build-wd-views.sh && build-movie-fixes.sh && build-tv-view.sh`
