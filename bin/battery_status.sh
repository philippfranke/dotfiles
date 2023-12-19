#!/bin/zsh
# Gets information about the battery status and prints the current battery percentage.

# Check for MacOS (Darwin)
if [[ "$(uname)" != "Darwin" ]]; then
  echo "N/A"
  exit 0
fi

# Fetch battery information from system registry.
battery_info=$(ioreg -l -n AppleSmartBattery -r)

# Extract current capacity from the battery information.
current_capacity=$(echo "$battery_info" | grep AppleRawCurrentCapacity | awk '{printf "%.2f", $3; exit}')

# Extract maximum capacity from the battery information.
max_capacity=$(echo "$battery_info" | grep "AppleRawMaxCapacity" | tail -1 | awk '{print $3; exit}')

# Calculate and print the battery percentage.
battery_percentage=$((current_capacity * 100 / max_capacity))
printf "%.2f%%\n" "$battery_percentage"
