# 06 - Tailscale remote access

## Why Tailscale
- SLT fiber commonly sits behind **CGNAT**, so plain WireGuard can't receive inbound connections
- No port forwarding, nothing exposed to the internet
- Free personal plan. (Clients are open source; the coordination server isn't. Headscale is the OSS alternative.)

## Host as subnet router
```bash
# signed apt repo for trixie, then:
apt install -y tailscale
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/99-tailscale.conf && sysctl -p /etc/sysctl.d/99-tailscale.conf
tailscale up --advertise-routes=192.168.1.0/24 --accept-dns=false
```
Admin console: route `192.168.1.0/24` approved, **key expiry disabled** on `pve`.

IPv6 forwarding is deliberately left off: enabling it would stop the host accepting router advertisements.

## DNS
- Global nameserver `192.168.1.201` (AdGuard) with **Override DNS servers** on
- MagicDNS on, so `http://pve:8006` works from tailnet devices
- Remote queries appear in AdGuard as `192.168.1.200` (subnet router SNAT)

## Data usage
Local streaming never touches the 50 GB ISP quota. Remote streaming counts twice
(home upload plus mobile download), so set client quality to 2–4 Mbps when away.

## Security notes
- The Google account behind the tailnet is the key to the whole LAN, so it needs 2-Step Verification
- Possible future step: ACLs restricting less-trusted devices to SSH and web UIs only
