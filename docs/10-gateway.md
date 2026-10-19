# 10 — Gateway: names, HTTPS and dashboard (CT 104)

**CT 104 `gateway`** — Debian 13, unprivileged, 2 cores / 2 GB / 8 GB, `192.168.1.204`.

## Names
AdGuard DNS rewrite `*.home.arpa → 192.168.1.204`. Devices not using AdGuard
(work laptop) get the names via `/etc/hosts`.

| Name | Backend |
|---|---|
| home.home.arpa | Homepage (127.0.0.1:3000) |
| proxmox.home.arpa | 192.168.1.200:8006 |
| grafana.home.arpa | 192.168.1.202:3000 |
| prometheus.home.arpa | 192.168.1.202:9090 |
| adguard.home.arpa | 192.168.1.201 |
| jellyfin.home.arpa | 192.168.1.203:8096 |

`home.arpa` is the reserved domain for home networks (RFC 8375), so it never
clashes with real sites.

## HTTPS
Caddy reverse proxy with its own CA, **name-constrained to `home.arpa`**: the
root can only sign `*.home.arpa`, so trusting it on a device can't be abused to
impersonate real websites. Root cert at `/etc/caddy/pki/root.crt`, trusted on
the Mac (login keychain) and iPhone. The private key never leaves the gateway.

## Dashboard
Homepage built from source (Node 22 from NodeSource; Debian's Node was too old).
Runs as an unprivileged `homepage` user, bound to 127.0.0.1 so the only way in
is through Caddy.

Live widgets: Proxmox (read-only token `homepage@pve!dashboard`, PVEAuditor),
AdGuard, Prometheus, Jellyfin (API key, `version: 2` header auth), plus
per-container CPU/RAM via `proxmox.yaml`.

Secrets live in `/etc/homepage.env` (mode 600, loaded by a systemd drop-in) and
are referenced as `{{HOMEPAGE_VAR_*}}`, so the YAML in this repo has no secrets.

## Gotchas
- Debian 13's Node.js fails the build (`markAsUncloneable is not a function`): use Node 22.
- Jellyfin 10.11+ rejects `?api_key=`: header auth only, hence `version: 2`.
- Homepage only serves images present at build time: the background is served
  by Caddy from `/srv/homelab` instead.
- `curl -I` against Proxmox returns 501: pveproxy doesn't implement HEAD.
