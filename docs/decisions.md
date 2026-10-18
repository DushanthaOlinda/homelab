# Architecture decision records

| # | Decision | Why | Trade-off |
|---|---|---|---|
| 1 | Proxmox VE as base | VMs/LXC for broader lab work; keeps existing drive data | More moving parts than a NAS OS |
| 2 | ext4 not ZFS on root | Single disk, 16 GB RAM | No checksumming/snapshots at FS level |
| 3 | Unprivileged LXC for all services | Isolation with minimal overhead (shared kernel) | GPU/mount passthrough needs ID care |
| 4 | Non-root admin + key-only SSH, no 2FA | LAN-only exposure | Revisit if anything becomes internet-facing |
| 5 | AdGuard per-device DNS | Router DHCP DNS locked by ISP | Guests/TVs not covered |
| 6 | Prometheus + Grafana over lighter tools | Industry-standard, career-relevant | Heavier than Beszel/Uptime Kuma |
| 7 | Read-only Proxmox API token (PVEAuditor) | Least privilege | - |
| 8 | Tailscale subnet router, no port forwards | CGNAT-proof, zero exposed ports | Third-party coordination server |
| 9 | WD archive strictly read-only | Unreplayed NTFS journal; irreplaceable content | Can't add `.ignore` → symlink views |
| 10 | Symlink views, not automated | Archive never changes; automation risks wiping the library | Manual rerun when the show list changes |
| 11 | Roaming laptops excluded from AdGuard DNS | macOS DNS is interface-wide; a home-only resolver breaks DNS on other networks | No ad blocking on those laptops |
