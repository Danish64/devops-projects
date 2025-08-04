#!/bin/bash

# log-archive.sh: Compresses logs from a specified directory into a timestamped .tar.gz file.

# --- Validation ---
# Check if exactly one argument is provided.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <log-directory>"
    echo "Please provide the absolute path to the directory containing the logs."
    exit 1
fi

LOG_DIR=$1

# Check if the provided argument is a directory and is readable.
if [ ! -d "$LOG_DIR" ] || [ ! -r "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' not found or is not readable."
    exit 1
fi

# --- Main Script ---
# Create the directory to store the archives if it doesn't already exist.
ARCHIVE_DIR="/tmp/log-archives"
mkdir -p "$ARCHIVE_DIR"

# Create a timestamped filename for the archive.
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_FILE="$ARCHIVE_DIR/logs_archive_$TIMESTAMP.tar.gz"

# Compress the logs from the specified directory into the archive file.
# The -C option changes the directory to keep the paths in the archive relative.
tar -czf "$ARCHIVE_FILE" -C "$LOG_DIR" .

# Check if the archive was created successfully.
if [ $? -eq 0 ]; then
    echo "Successfully created archive: $ARCHIVE_FILE"
    # Log the archive creation to a file.
    echo "$TIMESTAMP: Archived logs from '$LOG_DIR' to '$ARCHIVE_FILE'" >> "$ARCHIVE_DIR/archive.log"
else
    echo "Error: Failed to create archive."
    exit 1
fi