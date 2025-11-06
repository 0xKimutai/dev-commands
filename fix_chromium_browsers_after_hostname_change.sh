#!/bin/bash
# =====================================================
#  Chromium-Based Browser Fixer After Hostname Change
#  Works for: Google Chrome, Brave, Edge, Chromium
#  Author: Kevin Kimutai
# =====================================================

# --- Step 1: Require sudo privileges ---
if [ "$EUID" -ne 0 ]; then
  echo "  Please run this script as root (use: sudo ./fix_chromium_browsers_after_hostname_change.sh)"
  exit 1
fi

echo "==============================================="
echo "     Chromium Browser Hostname Fix Utility"
echo "==============================================="

# --- Step 2: Detect current and old hostname ---
current_hostname=$(cat /etc/hostname)
echo "Current hostname detected: $current_hostname"
read -p "Enter your previous hostname (e.g., thinkpad-ubuntu): " old_hostname

if [ -z "$old_hostname" ]; then
  echo "No old hostname entered. Exiting."
  exit 1
fi

echo
echo "🔧 Fixing Chromium-based browser configs..."
echo

# --- Step 3: Define config paths ---
BROWSER_PATHS=(
  "$HOME/.config/google-chrome"
  "$HOME/.config/chromium"
  "$HOME/.config/BraveSoftware/Brave-Browser"
  "$HOME/.config/microsoft-edge"
)

# --- Step 4: Loop through each browser path ---
for path in "${BROWSER_PATHS[@]}"; do
  if [ -d "$path" ]; then
    echo " Processing: $path"

    # Clear lock files
    rm -f "$path"/Singleton*

    # Replace old hostname with new one in configs
    sed -i "s/$old_hostname/$current_hostname/g" "$path"/Local\ State 2>/dev/null
    sed -i "s/$old_hostname/$current_hostname/g" "$path"/Default/Preferences 2>/dev/null

    # Fix ownership just in case
    chown -R $SUDO_USER:$SUDO_USER "$path"

    echo "Fixed: $path"
    echo
  fi
done

# --- Step 5: Verify /etc/hosts consistency ---
echo "Checking /etc/hosts consistency..."
if ! grep -q "$current_hostname" /etc/hosts; then
  echo "  /etc/hosts does not contain '$current_hostname'."
  echo "Adding it now..."
  echo "127.0.1.1   $current_hostname" >> /etc/hosts
fi

# --- Step 6: Completion message ---
echo "All done! Browsers should now launch normally."
echo "Tip: Reboot your system for best results."
echo "Run: sudo reboot"
echo "-----------------------------------------------"
