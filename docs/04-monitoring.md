# 04 - Monitoring (CT 102)

## Data flow
```
pve host: node-exporter :9100 ──┐
pve host: Proxmox API :8006 ────┼──> pve-exporter 127.0.0.1:9221 ──> Prometheus :9090 ──> Grafana :3000
                                └──────────────────────────────────> Prometheus
```

## Host side
```bash
apt install -y prometheus-node-exporter   # also brings SMART/NVMe collectors
systemctl disable --now prometheus-node-exporter-ipmitool-sensor.timer \
                        prometheus-node-exporter-mellanox-hca-temp.timer
# Read-only API identity (least privilege)
pveum user add prometheus@pve --comment "Prometheus exporter"
pveum acl modify / --users prometheus@pve --roles PVEAuditor
pveum user token add prometheus@pve exporter --privsep 0
```
The token secret lives only in the password manager and in `/etc/prometheus/pve.yml` (mode 600) inside CT 102.

## Container side
- Prometheus 2.53 from Debian repos (`--no-install-recommends`)
- Grafana OSS from Grafana's signed APT repo
- `prometheus-pve-exporter` in a Python venv at `/opt/pve-exporter`, systemd unit bound to localhost
- Configs: `configs/monitoring/`
- `GF_SERVER_ROOT_URL=http://192.168.1.202:3000/` in `/etc/default/grafana-server`, so alert links work from a phone

## Dashboards
| ID | Name |
|---|---|
| 1860 | Node Exporter Full |
| 10347 | Proxmox via Prometheus |
