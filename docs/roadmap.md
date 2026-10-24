# Roadmap

## Done
- [x] Proxmox VE install, hardening (non-root admin, key-only SSH)
- [x] AdGuard Home with encrypted upstream DNS
- [x] Prometheus + Grafana monitoring
- [x] Telegram alerting (tested end to end)
- [x] Tailscale remote access + DNS via AdGuard
- [x] External drives mounted (archive read-only)
- [x] Jellyfin with Intel Quick Sync, libraries organised
- [x] SD card verified with `f3` (0 errors across ~233 GB)
- [x] SD card registered as Proxmox backup storage ("is a mountpoint")
- [x] Nightly container backups to the SD card (7 daily + 4 weekly)
- [x] Irreplaceable data copied to the SD card (92,764 files, verified)
- [x] Gateway (CT 104): Caddy reverse proxy, `*.home.arpa` names
- [x] Local HTTPS with a name-constrained CA (trusted on Mac + iPhone)
- [x] Homepage dashboard with live widgets, secrets kept out of config
- [x] Alert: external drive missing (covers all 3 drives)
- [x] Temperature alert (CPU > 85 °C for 10 min)
- [x] Test-restore a container backup (CT 101 → temporary CT 901, verified)

## Next
- [x] WD archive drive: move to a USB 3.0 port / powered enclosure, remount
- [x] Sort misfiled episodes (numeric file names) on the WD drive into shows
- [x] Alert: external drive missing (all 3 drives)
- [ ] Re-enable SMART monitoring safely (skip sleeping drives)
- [ ] Route Proxmox backup notifications to Telegram
- [ ] Scheduled sync of personal files to the SD card
- [ ] Offsite copy (3-2-1)
- [ ] Kubernetes cluster (VMs) + Istio service mesh lab
- [ ] Try Pi-hole (+ Unbound) and compare with AdGuard Home
- [ ] Immich (self-hosted photos) once backups are in place
- [ ] Tailscale ACLs (restrict less-trusted devices)
- [ ] Alert rules exported as YAML into `configs/alerting/`
- [ ] Better Telegram message templates (distinct resolved text)
- [ ] Longer Ethernet cable → move server off the bed onto a desk
- [ ] Re-IP home network away from 192.168.1.0/24 (avoid overlap on remote networks)
- [ ] Infrastructure as code: Terraform (bpg/proxmox) + Ansible for the containers
