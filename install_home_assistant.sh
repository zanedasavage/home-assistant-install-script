#!/bin/bash
set -e

# Step 1: Update and install dependencies
sudo apt-get update
sudo apt-get install -y software-properties-common apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat

# Step 2: Install Docker
curl -fsSL https://get.docker.com | sh

# Step 3: Install OS Agent
OS_AGENT_VERSION="1.6.0"
OS_AGENT_ARCH="amd64"
curl -Lo os-agent.deb "https://github.com/home-assistant/os-agent/releases/download/${OS_AGENT_VERSION}/os-agent_${OS_AGENT_VERSION}_linux_${OS_AGENT_ARCH}.deb"
sudo dpkg -i os-agent.deb
rm os-agent.deb

# Step 4: Install Home Assistant Supervised
HASSIO_INSTALLER_VERSION="latest"
curl -Lo homeassistant-supervised.deb "https://github.com/home-assistant/supervised-installer/releases/download/${HASSIO_INSTALLER_VERSION}/homeassistant-supervised.deb"
sudo dpkg -i homeassistant-supervised.deb
rm homeassistant-supervised.deb

# Step 5: Ensure Docker service is running
sudo systemctl restart docker
sudo systemctl restart hassio-supervisor

# Step 6: Check the status of Docker and Home Assistant Supervisor
echo "Checking the status of Docker and Home Assistant Supervisor services..."
sudo systemctl status docker --no-pager
sudo systemctl status hassio-supervisor --no-pager

echo "Script execution completed."
