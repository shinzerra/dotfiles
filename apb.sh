#!/bin/bash

# Function to run the xrandr scaling script
run_scaling_script() {
    ./xrandr-scale.txt
}

# Run the initial xrandr scaling script
run_scaling_script

# Define the workspace number (choose a number that is not in use)
WORKSPACE_NUMBER=1

# kill compositor
pkill picom

# Switch to a new workspace
i3-msg workspace $WORKSPACE_NUMBER

# Launch the Steam game with App ID 113400
steam steam://rungameid/113400 &

# Wait 2 minutes to allow the game to fully launch
sleep 120

# Set the game process name to monitor
GAME_PROCESS="APB.exe"  # The name of the process for APB Reloaded

# Wait until the game process is detected
while ! pgrep -f "$GAME_PROCESS" > /dev/null; do
    sleep 1  # Check every second
done

echo "APB Reloaded is running. Waiting for the game to close..."

# Now wait until the game process ends
while pgrep -f "$GAME_PROCESS" > /dev/null; do
    sleep 1  # Check every second
done

echo "APB Reloaded has closed."

# run compositor
picom -f 

# Run the scaling script again after the game closes
run_scaling_script
