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

## Next
- [ ] Register SD card as Proxmox backup storage ("is a mountpoint")
- [ ] Copy irreplaceable data (~67 GB) to the SD card → second copy
- [ ] Nightly vzdump of CT 101–103 to the SD card + retention policy
- [ ] Offsite copy (3-2-1)
- [ ] Immich (self-hosted photos) once backups are in place
- [ ] Tailscale ACLs (restrict less-trusted devices)
- [ ] Alert rules exported as YAML into `configs/alerting/`
- [ ] Better Telegram message templates (distinct resolved text)
- [ ] Temperature / SMART alerts
- [ ] Longer Ethernet cable → move server off the bed onto a desk
- [ ] Infrastructure as code: Terraform (bpg/proxmox) + Ansible for the containers
