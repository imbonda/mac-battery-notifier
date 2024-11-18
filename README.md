# `macOS` Battery Notifier 🪫🔋

A lightweight system daemon for macOS that monitors battery levels and sends notifications when the battery is either too low or sufficiently charged. 

---
![alt text](images/low-battery.png)
![alt text](images/high-battery.png)

---

## Purpose

The macOS Battery Notifier Daemon ensures you never miss critical battery updates. It runs in the background, sending system notifications when:  
1. **The battery level drops below a defined threshold** (e.g., 25%).  
2. **The battery is sufficiently charged** (e.g., 80%).  

This helps you keep your battery healthy, avoid unexpected shutdowns and overcharging your device.  

---

## Installation

### Step 1: Copy Files
1. Copy the main script and the `.plist` file to their respective locations:
   ```bash
   sudo cp scripts/battery_notifier.sh /usr/local/bin/
   sudo cp config/bonda.battery.notifier.plist /Library/LaunchDaemons/
   ```

### Step 2: Set Permissions
2. Make the script executable:
   ```bash
   sudo chmod +x /usr/local/bin/battery_notifier.sh
   ```
3. Ensure proper ownership of the files:
   ```bash
   sudo chown root:wheel /usr/local/bin/battery_notifier.sh
   sudo chown root:wheel /Library/LaunchDaemons/bonda.battery.notifier.plist
   ```

### Step 3: Load the Daemon
4. Load the LaunchDaemon to start monitoring:
   ```bash
   sudo launchctl load /Library/LaunchDaemons/bonda.battery.notifier.plist
   ```

### Step 4: Verify
5. Confirm the daemon is running:
   ```bash
   sudo launchctl list | grep bonda.battery.notifier.plist
   ```

---

## Uninstallation

1. Unload the Daemon:
   ```bash
   sudo launchctl unload /Library/LaunchDaemons/bonda.battery.notifier.plist
   ```

2. Remove the Files:
   ```bash
   sudo rm /Library/LaunchDaemons/bonda.battery.notifier.plist
   sudo rm /usr/local/bin/battery_notifier.sh
   ```

---

## Notes

- Customize the low-battery and high-battery thresholds by editing the battery_notifier.sh script before installation.
- Administrative privileges are required to manage system daemons.
- Ensure the .plist file points to the correct path of the script (e.g., /usr/local/bin/battery_notifier.sh).