# 01 - Proxmox VE install

## Choice
Proxmox VE over TrueNAS / Unraid / OMV / plain Ubuntu:
- Hypervisor-first: VMs and LXC containers for lab work beyond media
- External drives already held data, and TrueNAS would want to wipe them for ZFS
- Free and open source (AGPLv3); the subscription is only for the enterprise repo

## Install
- ISO: Proxmox VE 9.2 (amd64), checksum verified, flashed with balenaEtcher
- BIOS: VT-x and VT-d on, storage mode **AHCI**, battery **Primarily AC Use**
- Target: internal NVMe, **ext4** (single disk + 16 GB RAM, so ZFS isn't worth the overhead)
- Network: `nic0` (e1000e), static `192.168.1.200/24`, gw `192.168.1.1`, hostname `pve.home.arpa`
- "Pin network interface names" enabled, so the NIC name survives kernel updates
- Installed **offline** before moving the machine home, using the *home* network values

Resulting layout:

| Volume | Size | Storage ID | Use |
|---|---|---|---|
| pve-root | 96 G | `local` | OS, ISOs, templates |
| pve-swap | 8 G | - | swap |
| pve-data (thin pool) | 349 G | `local-lvm` | container / VM disks |

## Post-install
1. **Clock:** the BIOS clock was months off; chrony corrected it once online (`timedatectl`).
2. **Repos:** disabled `pve-enterprise` and `ceph enterprise`, added `pve-no-subscription`
   and `ceph-squid no-subscription` (Node → Updates → Repositories).
3. **Update:** `apt update && apt full-upgrade -y`, never plain `apt upgrade` on Proxmox. Reboot into the new kernel.

## microSD card as backup target
```bash
mkfs.ext4 -L sdcard /dev/mmcblk0p1
mkdir -p /mnt/sdcard
# fstab line: see configs/proxmox/fstab.snippet
tune2fs -m 0 /dev/mmcblk0p1   # no root-reserved blocks on a data disk
```
Tested for fake capacity / bad flash with `f3write` + `f3read` (in a detached tmux session).
