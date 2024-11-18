#!/bin/bash

# Paths to temporary files that track notification state
LOW_BATTERY_NOTIF_FILE="/tmp/low_battery_notified"
HIGH_BATTERY_NOTIF_FILE="/tmp/high_battery_notified"

LOW_BATTERY=25
HIGH_BATTERY=80

low_level_notif_cmd='osascript -e "display notification \"🪫 Battery level below '$LOW_BATTERY'% 🪫\" with title \"Low Battery\" sound name \"Ping\""'
high_level_notif_cmd='osascript -e "display notification \"🔋 Battery level above '$HIGH_BATTERY'% 🔋\" with title \"Battery Charged\" sound name \"Ping\""'
 
# Get current logged in user
target_user=$(who | grep console | awk '{print $1}' | head -n 1)
if [ -n "$target_user" ]; then
    low_level_notif_cmd="sudo su - $target_user -c '$low_level_notif_cmd'"
    high_level_notif_cmd="sudo su - $target_user -c '$high_level_notif_cmd'"
fi

# Get current battery percentage
battery_level=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
# Get charging status
charging_status=$(pmset -g batt | grep -o "discharging\|charging")

# Low battery notification if below low battery level and no notification sent
if [[ "$charging_status" == "discharging" ]]; then
    rm -f "$HIGH_BATTERY_NOTIF_FILE" # Reset high battery notification state
    if [[ "$battery_level" -lt "$LOW_BATTERY" && ! -f "$LOW_BATTERY_NOTIF_FILE" ]]; then
        eval "$low_level_notif_cmd"
        touch "$LOW_BATTERY_NOTIF_FILE"  # Create file to mark that the notification was sent
    fi
fi

# High battery notification if above high battery level and no notification sent
if [[ "$charging_status" == "charging" ]]; then
    rm -f "$LOW_BATTERY_NOTIF_FILE"   # Reset low battery notification state
    if [[ "$battery_level" -gt "$HIGH_BATTERY" && ! -f "$HIGH_BATTERY_NOTIF_FILE" ]]; then
        eval "$high_level_notif_cmd"
        touch "$HIGH_BATTERY_NOTIF_FILE"  # Create file to mark that the notification was sent
    fi
fi
