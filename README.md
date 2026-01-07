# Argus Monitoring Stack

Argus is the central monitoring solution for the Homelab, built on Prometheus and Grafana. It provides real-time metrics, alerting, and visualization for the entire infrastructure.

## Services

- **Prometheus**: Time-series database for collecting metrics.
  - URL: `https://prometheus.yourdomain.com` (Protected by Authelia)
  - Config: `/opt/argus/configs/prometheus/prometheus.yml`
- **Grafana**: Visualization platform for dashboards.
  - URL: `https://grafana.yourdomain.com` (Protected by Authelia)
- **Node Exporter**: Hardware and OS metrics collector (deployed globally).
- **cAdvisor**: Container resource usage collector (deployed globally).

## Deployment

The stack is deployed via GitHub Actions on the `gaia` manager node utilizing Docker Swarm.

### CI/CD Pipeline
1. **Checkout**: Recursively clones the repo and submodules.
2. **Deploy**: Executes `scripts/deploy.sh` to update the `argus` stack.
