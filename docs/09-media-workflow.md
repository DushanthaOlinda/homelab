# 09 - Media workflow

```
Personal laptop ──> ~/Documents/Media/{Movies,Shows}  (staging folder)
At home on the LAN ──> pushmedia ──> /mnt/olinda/Media ──> Jellyfin real-time scan
```

New media is staged on my personal laptop, then handed off to the lab over the home
network with `scripts/pushmedia.sh` (rsync over SSH). Transfers stay on the LAN, so
they don't count against the ISP data quota.

What the script does:
- `--remove-source-files`: frees space on the laptop only after each file transfers successfully
- `--partial`: interrupted transfers resume where they stopped
- `--backup --backup-dir=.replaced/<date>`: an overwritten server file is moved aside, never lost
- Excludes `.DS_Store` and `._*` macOS metadata files

## Overlap behaviour
| Case | Result |
|---|---|
| Same name, same file | skipped, laptop copy removed |
| New season, same show folder name | merges into the existing show |
| Same name, different file | server copy moved to `.replaced/` |
| Same title, different name | duplicate in Jellyfin, so match server folder names before pushing |

## Naming
Shows go in `Shows/Show Name (Year)/`, using the same folder name as on the server,
so new seasons merge cleanly. Check existing names with:

```bash
ssh pve 'ls /mnt/olinda/Media/Shows'
```

## Rule of thumb
Only run `pushmedia` on the home network. The same command works over Tailscale,
but then every GB counts against the home quota.
