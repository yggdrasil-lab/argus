#!/bin/bash
# One-time setup script to prepare the host directories
# Run this on the manager node before the first deployment

echo "Preparing host directories for Argus..."
sudo mkdir -p /opt/argus/configs/prometheus
sudo chown -R 1000:1000 /opt/argus
echo "Directories created and ownership set to $USER:"
ls -R /opt/argus
