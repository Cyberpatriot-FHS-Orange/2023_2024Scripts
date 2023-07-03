#!/bin/bash

# ========================================================
# CyberPatriot Competition Script for Ubuntu Linux
# ========================================================

# ----------------------------------------
# System Configuration
# ----------------------------------------
read -p "Run system configuration? (Y/N): " run_system_config
if [[ $run_system_config == "Y" || $run_system_config == "y" ]]; then
    echo "Updating system packages..."
    sudo apt-get update -y

    echo "Upgrading system packages..."
    sudo apt-get upgrade -y

    echo "Disabling guest account..."
    sudo sh -c "printf '[SeatDefaults]\nallow-guest=false\n' > /etc/lightdm/lightdm.conf.d/50-no-guest.conf"

    echo "Enabling automatic security updates..."
    sudo apt-get install unattended-upgrades -y
    sudo dpkg-reconfigure --priority=low unattended-upgrades
fi

# ----------------------------------------
# User Accounts and Passwords
# ----------------------------------------
read -p "Run user accounts and passwords setup? (Y/N): " run_user_accounts
if [[ $run_user_accounts == "Y" || $run_user_accounts == "y" ]]; then
    echo "Setting up user accounts..."

    # Read user accounts and passwords from file
    while IFS=, read -r username password; do
        echo "Creating user: $username"
        sudo adduser --disabled-password --gecos "" $username
        echo "$username:$password" | sudo chpasswd
    done < user_accounts.txt

    echo "Deleting user accounts not in the list..."
    existing_users=$(cut -d: -f1 /etc/passwd)
    while IFS= read -r user; do
        if [[ ! $existing_users =~ (^|[[:space:]])$user($|[[:space:]]) ]]; then
            echo "Deleting user: $user"
            sudo deluser --remove-home $user
        fi
    done < user_accounts.txt
fi

# ----------------------------------------
# User Permissions
# ----------------------------------------
read -p "Run user permissions setup? (Y/N): " run_user_permissions
if [[ $run_user_permissions == "Y" || $run_user_permissions == "y" ]]; then
    echo "Setting user permissions..."

    # Read user accounts and permissions from file
    while IFS=, read -r username permission; do
        echo "Setting permissions for user: $username"
        if [[ $permission == "admin" ]]; then
            sudo usermod -aG sudo $username
        else
            sudo deluser $username sudo
        fi
    done < user_permissions.txt
fi

# ----------------------------------------
# Unnecessary Services
# ----------------------------------------
read -p "Run unnecessary services setup? (Y/N): " run_unnecessary_services
if [[ $run_unnecessary_services == "Y" || $run_unnecessary_services == "y" ]]; then
    echo "Stopping and disabling unnecessary services..."
    sudo systemctl stop telnet
    sudo systemctl disable telnet
    sudo systemctl stop vsftpd
    sudo systemctl disable vsftpd
    sudo systemctl stop apache2
    sudo systemctl disable apache2
    sudo systemctl stop cups
    sudo systemctl disable cups
    sudo systemctl stop smbd
    sudo systemctl disable smbd
fi

# ----------------------------------------
# Network Configuration
# ----------------------------------------
read -p "Run network configuration setup? (Y/N): " run_network_configuration
if [[ $run_network_configuration == "Y" || $run_network_configuration == "y" ]]; then
    echo "Configuring network settings..."

    echo "Disabling IPv6..."
    sudo sh -c "printf '\n\n# Disable IPv6\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1\n' >> /etc/sysctl.conf"
    sudo sysctl -p

    echo "Enabling UFW (Uncomplicated Firewall)..."
    sudo ufw enable

    echo "Configuring UFW rules..."
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
fi

# ----------------------------------------
# Software Updates
# ----------------------------------------
read -p "Run software updates? (Y/N): " run_software_updates
if [[ $run_software_updates == "Y" || $run_software_updates == "y" ]]; then
    echo "Performing software updates..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo apt-get autoremove -y
fi

# ----------------------------------------
# Install Additional Apps
# ----------------------------------------
read -p "Run additional apps installation? (Y/N): " run_additional_apps
if [[ $run_additional_apps == "Y" || $run_additional_apps == "y" ]]; then
    echo "Installing additional apps..."

    # Install Chocolatey if not already installed
    if ! command -v choco &> /dev/null; then
        echo "Installing Chocolatey..."
        sudo apt-get install -y curl
        sudo curl -fsSL https://chocolatey.org/install.sh | sudo bash
    fi

    # Read additional apps from file and install using Chocolatey
    while IFS= read -r app; do
        echo "Installing $app..."
        sudo choco install $app -y
    done < additional_apps.txt
fi

# ----------------------------------------
# Cleanup and Final Steps
# ----------------------------------------
read -p "Run cleanup and final steps? (Y/N): " run_cleanup
if [[ $run_cleanup == "Y" || $run_cleanup == "y" ]]; then
    echo "Cleaning up temporary files..."
    sudo rm -rf /tmp/*
    sudo apt-get clean
    sudo apt-get autoclean
    sudo updatedb
fi

echo "Script execution completed."
read -p "Press Enter to exit."
