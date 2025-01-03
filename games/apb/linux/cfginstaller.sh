#!/bin/bash

# Set variables
ZIP_URL="https://github.com/shinzerra/apb/releases/download/apb1.0.3/apbcfg.zip"
DEST_DIR="$HOME/apbconfig"
ZIP_FILE="$HOME/apbcfg.zip"

# Download the zip file
echo "Downloading apbcfg.zip from GitHub..."
wget -O "$ZIP_FILE" "$ZIP_URL"

# Create the destination directory
echo "Creating destination directory: $DEST_DIR"
mkdir -p "$DEST_DIR"

# Extract the zip file into the destination directory
echo "Extracting apbcfg.zip to $DEST_DIR..."
unzip -q "$ZIP_FILE" -d "$DEST_DIR"

# Clean up the zip file
echo "Cleaning up..."
rm "$ZIP_FILE"

# Verify the structure
if [ -d "$DEST_DIR/APBGame" ] && [ -d "$DEST_DIR/Engine" ]; then
    echo "Extraction successful!"
    echo "APBGame and Engine directories are located in $DEST_DIR."
else
    echo "Error: Expected directory structure not found."
fi
