# Roadmap

- [x] SD card: pass `f3`, register as Proxmox backup storage ("is a mountpoint")
- [ ] Copy irreplaceable data (~67 GB) to the SD card → second copy
- [ ] Nightly vzdump of CT 101–103 to the SD card + retention policy
- [ ] Offsite copy (3-2-1)
- [ ] Immich (self-hosted photos) once backups are in place
- [ ] Tailscale ACLs (restrict less-trusted devices)
- [ ] Alert rules exported as YAML into `configs/alerting/`
- [ ] Better Telegram message templates (distinct resolved text)
- [ ] Temperature / SMART alerts
- [ ] Infrastructure as code: Terraform (bpg/proxmox) + Ansible for the containers
