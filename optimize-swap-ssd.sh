#!/bin/bash
# ============================================
# Ubuntu Swap + ZRAM Optimization Script
# Author: Kevin Kimutai (0xKimutai)
# Description: 
#  - Creates 8GB swapfile
#  - Enables zram compression
#  - Sets SSD-safe swappiness
#  - Minimizes SSD wear and boosts performance
# ============================================

echo " Starting Ubuntu swap optimization setup..."

# --- Step 1: Disable current swap ---
echo "Disabling existing swap..."
sudo swapoff -a

# --- Step 2: Remove old swapfile if exists ---
if [ -f /swapfile ]; then
    echo "Removing old swapfile..."
    sudo rm /swapfile
fi

# --- Step 3: Create new 8GB swapfile ---
echo "Creating new 8GB swapfile..."
sudo fallocate -l 8G /swapfile || sudo dd if=/dev/zero of=/swapfile bs=1M count=8192 status=progress

# --- Step 4: Secure the swapfile ---
echo "Setting correct permissions..."
sudo chmod 600 /swapfile

# --- Step 5: Set up and enable swap ---
echo "Configuring swap..."
sudo mkswap /swapfile
sudo swapon /swapfile

# --- Step 6: Ensure persistence across reboots ---
if ! grep -q "/swapfile none swap sw 0 0" /etc/fstab; then
    echo "Adding swap entry to /etc/fstab..."
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
fi

# --- Step 7: Set SSD-safe swappiness ---
echo "Setting vm.swappiness to 10..."
sudo sysctl vm.swappiness=10
if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
else
    sudo sed -i 's/^vm.swappiness=.*/vm.swappiness=10/' /etc/sysctl.conf
fi

# --- Step 8: Reduce cache pressure (optional performance tweak) ---
if ! grep -q "vm.vfs_cache_pressure" /etc/sysctl.conf; then
    echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
else
    sudo sed -i 's/^vm.vfs_cache_pressure=.*/vm.vfs_cache_pressure=50/' /etc/sysctl.conf
fi

# --- Step 9: Install and enable zram ---
echo "Installing zram-tools..."
sudo apt update -y && sudo apt install zram-tools -y

echo "Configuring zram to use 25% of RAM..."
sudo sed -i 's/^PERCENT=.*/PERCENT=25/' /etc/default/zramswap 2>/dev/null || echo "PERCENT=25" | sudo tee -a /etc/default/zramswap

echo "Enabling zram service..."
sudo systemctl enable zramswap.service
sudo systemctl restart zramswap.service

# --- Step 10: Verify setup ---
echo
echo "Setup complete! Current swap configuration:"
swapon --show
echo
echo "Swappiness: $(cat /proc/sys/vm/swappiness)"
echo "ZRAM configuration: $(cat /sys/block/zram0/disksize 2>/dev/null)"
echo " Optimization successful — your SSD is now protected and performance boosted!"
