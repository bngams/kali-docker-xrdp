#!/bin/bash
set -e

# Use environment variables with defaults
RDP_USER=${RDP_USER:-kali}
RDP_PASSWORD=${RDP_PASSWORD:-kali}

# Create user if doesn't exist
if ! id "$RDP_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$RDP_USER"
    echo "$RDP_USER:$RDP_PASSWORD" | chpasswd
    # Add user to sudo group
    usermod -aG sudo "$RDP_USER"
    echo "$RDP_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    echo "User $RDP_USER created successfully with sudo privileges"
else
    echo "User $RDP_USER already exists"
    echo "$RDP_USER:$RDP_PASSWORD" | chpasswd
fi
