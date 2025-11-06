#!/bin/bash
# =====================================================
#  Ubuntu Hostname Changer Script
#  Safely rename your device (e.g., from thinkpad-ubuntu to Devpad)
#  Author: Kevin Kimutai
# =====================================================

# --- Step 1: Check for root privileges ---
if [ "$EUID" -ne 0 ]; then
  echo "  Please run this script as root (use: sudo ./change_hostname.sh)"
  exit 1
fi

echo "==========================================="
echo "     Ubuntu Hostname Change Utility"
echo "==========================================="

# --- Step 2: Show current hostname ---
current_hostname=$(hostnamectl --static)
echo "Current hostname: $current_hostname"

# --- Step 3: Ask user for new hostname ---
read -p "Enter new hostname (e.g., Devpad): " new_hostname

# --- Step 4: Set the new hostname using hostnamectl ---
echo "Setting new hostname to '$new_hostname'..."
hostnamectl set-hostname "$new_hostname"

# --- Step 5: Update /etc/hosts file safely ---
echo "Updating /etc/hosts file..."
sed -i "s/127\.0\.1\.1[[:space:]]*$current_hostname/127.0.1.1    $new_hostname/" /etc/hosts

# --- Step 6: Confirm changes ---
echo "Hostname successfully changed to: $(hostnamectl --static)"
echo
echo " All done!"

# --- Step 7: Suggest reboot ---
echo "To apply changes system-wide, please reboot:"
echo "sudo reboot"
echo "-------------------------------------------"
