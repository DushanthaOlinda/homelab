# 07 - Storage

## Drives
| Mount | Drive | FS | Mode | Contents |
|---|---|---|---|---|
| `/mnt/movies` | HGST 1 TB (WD Elements case) | NTFS | **read-only** | Movie archive (full) |
| `/mnt/olinda` | Seagate 1 TB | exFAT | rw, `olinda` only | `Media/`, personal backups |
| `/mnt/sdcard` | 256 GB microSD | ext4 | rw | Backup target |

fstab: `configs/proxmox/fstab.snippet`. Key options:
- `UUID=` rather than `/dev/sdX`, because device names swap between boots and replugs (this was observed)
- `nofail,x-systemd.device-timeout=10s`: a missing drive never hangs boot
- `dmask=0022,fmask=0133`: world-readable, so unprivileged containers can read without ID mapping
- Olinda `uid=1000`: only `olinda` can write, everything else reads

## Why the archive is read-only
- Irreplaceable to the owner, and the media can't be re-downloaded
- NTFS journal is "not replayed" (last ejected uncleanly from Windows); Linux can read
  safely but won't write. Forcing it (`ntfsfix`) would discard the journal. **Decision: never write.**

## Health
- SMART via `smartctl -d sat` (USB bridge). Reallocated/pending/offline-uncorrectable = 0
- `Reported_Uncorrect` raw value is a packed 48-bit field, not billions of errors
- `found.000-002` folders show a past CHKDSK repair → don't treat it as the only copy of anything
- Extended self-test: `smartctl -t long -d sat /dev/sdX`

## USB power lesson
Two bus-powered 2.5" drives at once caused `reset high-speed USB device` loops on one port.
Fixed by moving the drive to a different USB 3 port.

## Irreplaceable data (single copy, needs backup)
`LapBackup` 30G, `Phone Backup` 29G, `Documents` 1.4G, `Qbitum Trip 2024` 6.4G ≈ **67 GB** → SD card.
