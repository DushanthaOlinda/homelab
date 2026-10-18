# Runbook

## Access
| What | Where |
|---|---|
| Proxmox UI | https://192.168.1.200:8006 (user `olinda`, realm Linux PAM) |
| SSH | `ssh pve` (key only) |
| AdGuard | http://192.168.1.201 |
| Prometheus / Grafana | http://192.168.1.202:9090 / :3000 |
| Jellyfin | http://192.168.1.203:8096 |
| Remote | same addresses with Tailscale on |

## Routine
- Updates: `sudo apt update && sudo apt full-upgrade -y`; reboot if a new kernel is installed
- Containers: `apt update && apt full-upgrade -y` inside each
- New media: `pushmedia` from the Mac at home

## Recovery
| Symptom | Action |
|---|---|
| Can't reach anything | Check Ethernet cable / link (`dmesg \| grep nic0`), then local console |
| Wrong IP after a router change | Console: edit `/etc/network/interfaces` + `/etc/hosts`, then `ifreload -a` |
| Phone has no DNS | AdGuard down → check CT 101; toggle Tailscale off / remove manual DNS meanwhile |
| A drive is missing | Boot continues (`nofail`); replug, `sudo mount -a`; **do not** rerun build-wd-views.sh until WD is back |
| Alert links broken | Check `GF_SERVER_ROOT_URL` |
| Locked out of SSH | Local console as root (root password works there) |

## Long-running jobs
Run detached so a dropped SSH session doesn't kill them:
```bash
sudo tmux new -d -s job 'command; exec bash'
sudo tmux capture-pane -pt job | tail
```
