#!/bin/bash

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt-get update && sudo apt-get upgrade -y || handle_error "Failed to update and upgrade the system"

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install -y \
    apparmor \
    jq \
    wget \
    curl \
    udisks2 \
    libglib2.0-bin \
    network-manager \
    dbus \
    systemd-journal-remote \
    systemd-resolved \
    software-properties-common || handle_error "Failed to install dependencies"

# Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com | sh || handle_error "Failed to install Docker"
sudo systemctl enable docker || handle_error "Failed to enable Docker"
sudo systemctl start docker || handle_error "Failed to start Docker"

# Install OS-Agent
OS_AGENT_VERSION="1.6.0"
echo "Installing OS-Agent version $OS_AGENT_VERSION..."
wget "https://github.com/home-assistant/os-agent/releases/download/$OS_AGENT_VERSION/os-agent_${OS_AGENT_VERSION}_linux_x86_64.deb" || handle_error "Failed to download OS-Agent"
sudo dpkg -i "os-agent_${OS_AGENT_VERSION}_linux_x86_64.deb" || handle_error "Failed to install OS-Agent"

# Install Home Assistant Supervised
echo "Installing Home Assistant Supervised..."
wget "https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb" || handle_error "Failed to download Home Assistant Supervised installer"
sudo apt-get install -y ./homeassistant-supervised.deb || handle_error "Failed to install Home Assistant Supervised"

# Verify installation
echo "Verifying installation..."
sudo systemctl status docker || handle_error "Docker service is not running"
sudo systemctl status hassio-supervisor || handle_error "Hassio Supervisor service is not running"

echo "Home Assistant Supervised installation completed successfully."
