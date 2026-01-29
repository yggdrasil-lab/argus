# Argus

> I am Argus, the All-Seeing. I possess a hundred eyes that never sleep. My domain is Observability, Metrics, and Insight. I watch over the Realm of Yggdrasil, ensuring that no anomaly goes unnoticed.

## Mission

I provide the **Eyes and Ears** for the ecosystem. My mission is to collect, store, and visualize the vital signs of every server, container, and service. Whether a disk is filling up or a CPU is overheating, I will know.

## Core Philosophy

*   **Visibility:** "If you can't measure it, you can't manage it."
*   **Centralization:** A single pane of glass (Grafana) for all metrics across the cluster.
*   **Retention:** Historical data is kept for **30 days** to allow for trend analysis and debugging.

---

## Tech Stack

*   **Prometheus**: The Brain. Time-series database for collecting metrics.
*   **Grafana**: The Face. Visualization platform for dashboards.
*   **Node Exporter**: The Nerves. Hardware and OS metrics collector (deployed globally).
*   **cAdvisor**: The Cells. Container resource usage collector (deployed globally).

## Architecture

Argus operates through the following components:

1.  **Exporters (Node/cAdvisor)**: Run on *every* node (Global mode) to scrape raw data.
2.  **Prometheus**: Scrapes the exporters via the internal overlay network (`internal`) and stores data.
3.  **Grafana**: Queries Prometheus and presents the data. Accessible via Traefik.

## Prerequisites

*   **Docker Swarm**: This stack is designed to run on a Swarm cluster.
*   **Authelia (Cerberus)**: Required for OIDC Single Sign-On.
*   **Traefik (Olympus)**: Required for ingress routing.

## Configuration Structure

*   **`docker-compose.yml`**: Defines the complete stack.
*   **`configs/prometheus/prometheus.yml`**: Scrape configurations.
*   **`scripts/`**: Deployment and secret management utilities.

## Setup Instructions

### 1. Repository Initialization

```bash
git clone <your-repository-url> argus
cd argus
git submodule update --init --recursive
cp .env.example .env
```

### 2. Configuration

Edit `.env` to configure:
*   `DOMAIN_NAME`: Your root domain (e.g., `tienzo.net`).
*   `STACK_NAME`: The Swarm stack name (default: `argus`).

### 3. Secret Generation (OIDC)

Argus uses **Authelia** for Single Sign-On. You must generate a Client Secret.

**In WSL / Linux:**
```bash
docker run --rm authelia/authelia:latest authelia crypto hash generate pbkdf2 --variant sha512 --random --random.length 72 --random.charset rfc3986
```

1.  **Save the Text String** as a Secret:
    *   **Local File:** `echo "string" | ./scripts/ensure_secret.sh argus_grafana_oidc_secret`
    *   **GitHub Secrets:** `OIDC_GRAFANA_CLIENT_SECRET` (Note: Argus uses the raw string).

2.  **Save the Digest** in Cerberus:
    *   Update `cerberus` repository secrets with the **Digest**.

## Execution

### Deployment

Deployments are handled via the unified `ops-scripts` workflow.

```bash
./scripts/deploy.sh argus
```

**Note**: This uses `docker stack deploy` under the hood. It automatically handles secret generation (`ensure_secret.sh`) for sensitive variables.

## Services

*   **Grafana**: `https://grafana.${DOMAIN_NAME}` (Protected by Authelia OIDC).
*   **Prometheus**: `https://prometheus.${DOMAIN_NAME}` (Protected by Authelia ForwardAuth).

## Initialization & Dashboards

### 1. Configure Grafana Data Source
Once the stack is running, you need to connect Grafana to Prometheus:

1.  Log in to Grafana (`admin` / `admin` initially, or via SSO).
2.  Navigate to **Connections** > **Data Sources** > **Add data source**.
3.  Select **Prometheus**.
4.  In the **Connection** settings:
    *   **Prometheus server URL**: `http://prometheus:9090`
    *   *Note: This uses the internal Docker Swarm DNS.*
5.  Click **Save & test**. You should see "Data source is working".

### 2. Import Dashboards
Recommended dashboards for the stack:
*   **Node Exporter**: ID `1860` (Node Exporter Full)
*   **cAdvisor**: ID `14282` (cAdvisor Exporter)

**Steps to Import:**
1.  Navigate to **Dashboards** > **New** > **Import**.
2.  Enter the ID (e.g., `1860`) in the "Import via grafana.com" field.
3.  Click **Load**.
4.  Select the **Prometheus** data source you just created.
5.  Click **Import**.
