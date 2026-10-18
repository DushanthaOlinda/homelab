# 03 - AdGuard Home (CT 101)

## Container
Debian 13, unprivileged, 1 core / 512 MB / 4 GB, `192.168.1.201`, start at boot.

## Install
Official release binary (not the curl-pipe-sh installer):
```bash
cd /opt
wget https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz
tar xzf AdGuardHome_linux_amd64.tar.gz && rm AdGuardHome_linux_amd64.tar.gz
cd AdGuardHome && ./AdGuardHome -s install
chmod 700 /opt/AdGuardHome
timedatectl set-timezone Asia/Colombo
```
Setup wizard: web UI on port 80, DNS on port 53, all interfaces.

## Configuration
- **Upstreams (parallel):** `https://dns.quad9.net/dns-query`, `https://cloudflare-dns.com/dns-query`
- **Fallback:** `9.9.9.9`, `1.1.1.1`
- **Bootstrap:** Quad9 defaults
- **Blocklists:** AdGuard DNS filter + HaGeZi Multi NORMAL
- **Optimistic caching** on (≈1 ms repeat lookups)
- **Private reverse DNS** via the router for client names

## Client rollout
The SLT router's DHCP DNS fields are **locked**, so DNS is set per device:
- Phone: Wi-Fi → Configure DNS → Manual → `192.168.1.201`
- Remote devices: Tailscale global nameserver (see 06)
- **Roaming laptops excluded:** macOS DNS settings are interface-wide, so a home-only resolver would break DNS on other networks

## Known limits
- DNS blocking can't block YouTube video ads (same domains as content)
- iCloud Private Relay, browser "secure DNS", and hardcoded-DNS apps bypass it
