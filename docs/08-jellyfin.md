# 08 - Jellyfin (CT 103)

## Container
Debian 13, unprivileged, 4 cores / 4 GB / 16 GB, `192.168.1.203`, start at boot.

## Media and GPU passthrough (host, as root)
```bash
pct exec 103 -- getent group render        # → 992 in this container
pct shutdown 103
pct set 103 -mp0 /mnt/movies,mp=/media/wd,ro=1
pct set 103 -mp1 /mnt/olinda/Media,mp=/media/olinda,ro=1
pct set 103 -dev0 /dev/dri/renderD128,gid=992
pct start 103
```
- Only `Media/` from the Olinda drive is exposed, not the personal backups (least privilege)
- Both mounts are read-only inside the container

## Install
Jellyfin's signed APT repo (deb822 `.sources`, `Signed-By`), then:
```bash
apt install -y jellyfin
usermod -aG render jellyfin
runuser -u jellyfin -- /usr/lib/jellyfin-ffmpeg/vainfo --display drm --device /dev/dri/renderD128
```
vainfo confirmed the Intel iHD driver with HEVC Main10 decode/encode.

## Transcoding
Intel QuickSync (QSV), device `/dev/dri/renderD128`; HW decode for H264, HEVC, HEVC 10bit,
VP9, VP9 10bit, MPEG2, VC1, VP8; HW encoding on; **Low-Power encoders off** (needs host GuC/HuC firmware).

## Libraries
| Library | Folders |
|---|---|
| Movies | `/media/wd-movies`, `/media/olinda/Movies` |
| Shows | `/media/olinda/Shows`, `/media/wd/TV series`, `/media/wd-shows` |

Real-time monitoring on both. UPnP port mapping **off**.

## The WD symlink views
The read-only WD archive mixes shows inside movie folders (e.g. `Marvel/Loki`,
She-Hulk inside the Incredible Hulk folder), and `.ignore` files can't be written to it.
`scripts/build-wd-views.sh` builds two symlink trees on the container's own disk, driven by a show list kept on the server at `/etc/media-views/shows.list` (format in `scripts/shows.list.example`):
- `/media/wd-movies`: everything except listed shows and Windows system folders
- `/media/wd-shows`: listed shows with clean `Name (Year)` names

It refuses to run if the WD isn't mounted, because empty views would make Jellyfin drop the whole archive.
Not automated on purpose: the archive never changes.

## Naming
Shows on the writable drive use `Show Name (Year)/Season NN/`. Mismatches fixed via **Identify**.

## Clients
Jellyfin Media Player (Mac), Swiftfin / Jellyfin Mobile (phone). Server: `http://192.168.1.203:8096`.
