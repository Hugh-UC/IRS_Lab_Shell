#!/bin/bash

# --- Part 1: Move the override file ---

# The relative path from the scripts directory to the lib directory
OVERRIDE_FILE_SOURCE="../lib/compose.override.yaml"

# Ask the user for the path to the main lab repository
echo -e "| Enter the full path to the 'industrial-robots-and-systems-world'"
read -p "| directory: " lab_dir

# Define the path to the override file in the lab directory
OVERRIDE_FILE_DESTINATION="$lab_dir/compose.override.yaml"

# Check if the path exists and contains the main compose file
if [ ! -d "$lab_dir" ] || [ ! -f "$lab_dir/compose.yaml" ]; then
    echo -e "! Error: Directory not found or it does not contain 'compose.yaml'."
    exit 1
fi

# Check if the override file exists in the correct source location
if [ ! -f "$OVERRIDE_FILE_SOURCE" ]; then
    echo -e "! Error: The source override file '$OVERRIDE_FILE_SOURCE' was not found."
    exit 1
fi

# Copy the override file to the specified directory
cp "$OVERRIDE_FILE_SOURCE" "$OVERRIDE_FILE_DESTINATION"

echo -e "| Success! 'compose.override.yaml' has been copied to:\n| '$lab_dir'."

# --- Part 2: Update the volume path placeholder ---

# Define the user's home directory as the root for searching
SEARCH_ROOT="$HOME"

# Define the pattern for the directory
DIR_PATTERN="IRS_2025_*"

# Check if the override file already has a volume path set
# This assumes the placeholder is a unique string that won't appear elsewhere.
if grep -q "IRS_2025_" "$OVERRIDE_FILE_DESTINATION"; then
    echo -e "| Volume path already set in $OVERRIDE_FILE_DESTINATION.\n| Skipping directory creation."
    exit 0
fi

# Find the matching directory in the user's home directory
MATCHING_DIR=$(find "$SEARCH_ROOT" -maxdepth 1 -type d -name "$DIR_PATTERN" | head -n 1)

# Check if a matching directory was found
if [ -z "$MATCHING_DIR" ]; then
    echo -e "! No 'IRS_2025_n' directory found."
    echo -e "| Please enter your group number (n): "
    read GROUP_NUMBER
    
    # Create the new directory in the user's home directory
    NEW_DIR="$SEARCH_ROOT/IRS_2025_${GROUP_NUMBER}"
    mkdir -p "$NEW_DIR"
    echo -e "| Success! Created directory: $NEW_DIR"
    
    # Set the VOLUME_PATH variable for Docker Compose
    VOLUME_PATH="$NEW_DIR"
else
    # A matching directory was found, set the VOLUME_PATH
    VOLUME_PATH="$MATCHING_DIR"
    echo -e "| Success! Found existing directory: $VOLUME_PATH"
fi

# Replace the placeholder in the override file with the determined volume path
# The '-i' option modifies the file in place. It might require a suffix on some systems (e.g., 'sed -i.bak').
sed -i "s|PLACEHOLDER|${VOLUME_PATH}|g" "$OVERRIDE_FILE_DESTINATION"

echo -e "| Updated: $OVERRIDE_FILE_DESTINATION\n| with the volume path: ${VOLUME_PATH}"
echo -e "| You can now use:\n| - 'docker compose up', or\n| - 'docker compose down',\n| directly from your lab repository!"
echo -e "| DONE!"
