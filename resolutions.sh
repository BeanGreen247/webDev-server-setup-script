#!/bin/bash

# Check if xrandr and zenity are installed
if ! command -v xrandr &> /dev/null || ! command -v zenity &> /dev/null; then
    echo "Error: xrandr and/or zenity are not installed. Please install them."
    exit 1
fi

# Get the list of connected outputs
connected_outputs=$(xrandr | grep " connected" | awk '{print $1}')

# Check if there are no connected outputs
if [[ -z "$connected_outputs" ]]; then
    echo "No connected outputs found."
    exit 1
fi

# Select the first connected output (you can adjust this logic if needed)
connected_output=$(echo "$connected_outputs" | head -n 1)

# Define the list of resolutions
resolutions=("1280x720" "1366x768" "1600x900" "1920x1080")

# Add the resolutions using xrandr
for res in "${resolutions[@]}"; do
    xrandr --addmode "$connected_output" "$res"
done

# Prompt the user to pick a resolution
selected_resolution=$(zenity --list --title="Select Resolution" --column="Resolution" "${resolutions[@]}")

# Apply the selected resolution
xrandr --output "$connected_output" --mode "$selected_resolution"

exit 0
