# 05 - Alerting (Grafana → Telegram)

## Contact point
Telegram bot created via @BotFather. Bot token in the password manager; chat ID from `getUpdates`.
The default notification policy routes everything to the `telegram` contact point.

## Rules (folder `Homelab`, group `homelab`, evaluated every 1m)

| Rule | PromQL | Condition | Pending |
|---|---|---|---|
| Exporter down | `up` | below 1 | 2m |
| Container down | `pve_up{id=~"lxc/.*"}` | below 1 | 2m |
| Root disk > 85% | `100 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"} * 100)` | above 85 | 5m |
| local-lvm > 85% | `pve_disk_usage_bytes{id="storage/pve/local-lvm"} / pve_disk_size_bytes{id="storage/pve/local-lvm"} * 100` | above 85 | 5m |
| RAM > 90% | `100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)` | above 90 | 5m |

The `up` and `pve_up` rules are multi-dimensional: one alert instance per target or container,
so new containers are covered automatically.

## Tested end to end
Stopped `prometheus-node-exporter` on the host → **Firing** in about 3 min → started it → **Resolved**.

## As code
Export via Alerting → Alert rules → `Homelab` → Export (YAML) into `configs/alerting/`.
Remove anything secret before committing.
