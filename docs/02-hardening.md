# 02 - Hardening

## Non-root admin
```bash
apt install -y sudo
adduser olinda
usermod -aG sudo olinda
pveum user add olinda@pam
pveum acl modify / --users olinda@pam --roles Administrator
```
Daily work happens as `olinda` (SSH and web UI). `root@pam` is the break-glass account,
used only for root-only actions such as bind mounts.

## SSH
- Ed25519 key on the Mac (`ssh-keygen -t ed25519`), passphrase stored in the macOS Keychain
- `~/.ssh/config` host alias `pve`
- Server config in `configs/proxmox/sshd-hardening.conf`:
  - `PermitRootLogin prohibit-password`: no root password logins over SSH
  - `PasswordAuthentication no`: keys only
- Validate before restart: `sshd -t && systemctl restart ssh`

## Laptop as a server
- Lid close ignored: `configs/proxmox/logind-lid.conf` (systemd drop-in, survives upgrades)
- BIOS battery set to **Primarily AC Use**, so the battery doubles as a mini UPS without swelling
- `nofail` on every external mount, so a missing drive never blocks boot

## Router
- DHCP pool shrunk to `.2–.199` so the router never hands out homelab IPs
- No port forwarding at all. Remote access is via Tailscale only
