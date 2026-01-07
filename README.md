# Argus Monitoring Stack

Argus is the central monitoring solution for the Homelab, built on Prometheus and Grafana. It provides real-time metrics, alerting, and visualization for the entire infrastructure.

## Services

- **Prometheus**: Time-series database for collecting metrics.
  - URL: `https://prometheus.yourdomain.com` (Protected by Authelia)
  - Config: `/opt/argus/configs/prometheus/prometheus.yml`
- **Grafana**: Visualization platform for dashboards.
  - URL: `https://grafana.yourdomain.com` (Protected by Authelia)
  - Default Credentials: `admin` / `admin` (Change on first login)
- **Node Exporter**: Hardware and OS metrics collector (deployed globally).
- **cAdvisor**: Container resource usage collector (deployed globally).

## Deployment

The stack is deployed via GitHub Actions on the `gaia` manager node utilizing Docker Swarm.

### CI/CD Pipeline
1. **Checkout**: Recursively clones the repo and submodules.
2. **Deploy**: Executes `scripts/deploy.sh` to update the `argus` stack.

## Initialization & Configuration

### 1. Configure Grafana Data Source
Once the stack is running, you need to connect Grafana to Prometheus:

1. Log in to Grafana (`admin` / `admin`).
2. Navigate to **Connections** > **Data Sources** > **Add data source**.
3. Select **Prometheus**.
4. In the **Connection** settings:
   - **Prometheus server URL**: `http://prometheus:9090`
   - *Note: This uses the internal Docker Swarm DNS.*
5. Click **Save & test**. You should see "Data source is working".

### 2. Import Dashboards
You can now import pre-built dashboards for the stack:
- **Node Exporter**: ID `1860` (Node Exporter Full)
- **cAdvisor**: ID `14282` (cAdvisor Exporter)

**Steps to Import:**
1. Navigate to **Dashboards** > **New** > **Import**.
2. entering the ID (e.g., `1860`) in the "Import via grafana.com" field.
3. Click **Load**.
4. In the configuration dropdown, select the **Prometheus** data source you just created.
5. Click **Import**.
