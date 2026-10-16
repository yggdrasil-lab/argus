# Argus

> I am Argus, the All-Seeing. I possess a hundred eyes that never sleep. My domain is Observability, Metrics, and Insight. I watch over the Realm of Yggdrasil, ensuring that no anomaly goes unnoticed.

## Mission

I provide the **Eyes and Ears** for the ecosystem. My mission is to collect, store, and visualize the vital signs of every server, container, and service. Whether a disk is filling up or a CPU is overheating, I will know.

## Core Philosophy

* **Visibility:** "If you can't measure it, you can't manage it."
* **Centralization:** A single pane of glass (Grafana) for all metrics across the cluster.
* **Retention:** Historical data is kept for **30 days** to allow for trend analysis and debugging.

---

## Tech Stack

* **Prometheus**: Time-series database for collecting and storing metrics.
* **Grafana**: Visualization platform for dashboards with automated Prometheus datasource provisioning.
* **Node Exporter**: Hardware and OS metrics collector (deployed globally in host mode on port 9100).
* **cAdvisor**: Container resource usage collector (deployed globally).

## Architecture

1. **Exporters (Node/cAdvisor)**: Run on every node (Global mode) to scrape raw hardware and container metrics.
2. **Prometheus**: Scrapes Node Exporter (Gaia & Muspelheim), cAdvisor, and Traefik metrics (`:8082`) over `aether-net` and `internal`.
3. **Grafana**: Queries Prometheus and visualizes dashboards. Accessible via Traefik HTTPS with Authelia OIDC SSO.

## Prerequisites

* **Docker Swarm**: This stack is designed to run on a Swarm cluster.
* **Authelia (Cerberus)**: Required for OIDC Single Sign-On.
* **Traefik (Olympus)**: Required for ingress routing.

## Configuration Structure

* `docker-compose.yml`: Defines the complete stack with Swarm resource limits.
* `configs/prometheus/prometheus.yml`: Scrape configurations for Prometheus, Node Exporter, cAdvisor, and Traefik.
* `configs/grafana/datasources/prometheus.yaml`: Automated Grafana datasource provisioning.

## Deployment

Deployments follow the centralized GitOps workflow using `yggdrasil-os` deployment scripts (no git submodules).

```bash
curl -fsSL https://raw.githubusercontent.com/yggdrasil-lab/yggdrasil-os/main/deploy/deploy.sh -o /tmp/deploy.sh
chmod +x /tmp/deploy.sh
/tmp/deploy.sh "argus" docker-compose.yml
```

## Services

* **Grafana**: `https://grafana.${DOMAIN_NAME}` (Protected by Authelia OIDC).
* **Prometheus**: `https://prometheus.${DOMAIN_NAME}` (Protected by Authelia ForwardAuth).

## Dashboards

Prometheus is automatically provisioned as the default datasource on Grafana startup.

Recommended community dashboards:
* **Node Exporter Full**: ID `1860`
* **cAdvisor Exporter**: ID `14282`
* **Traefik Official**: ID `17346` or `4475`
