#!/bin/bash
#
# Script to create a new challenge writeup post in the required structure.
#
# Usage:
#   ./create_post.sh <challenge_name> [use_katex: 0|1]
#
# Example:
#   ./create_post.sh defcamp-blueprint 1

# --- Configuration ---
BASE_DIR="content/posts"
DEFAULT_FILENAME="index.md"
KATEX_TAG='{{< katex >}}'


# Check if challenge name is provided
if [ -z "$1" ]; then
    echo "Error: Challenge name is required."
    echo "Usage: $0 <challenge_name> [use_katex: 0|1]"
    exit 1
fi

CHALLENGE_NAME="$1"
POST_DIR="$BASE_DIR/$CHALLENGE_NAME"
FULL_PATH="$POST_DIR/$DEFAULT_FILENAME"

# Optional Katex flag (defaults to 0 if not provided)
USE_KATEX=${2:-0}

# Validate Katex flag (must be 0 or 1)
if [[ "$USE_KATEX" != "0" && "$USE_KATEX" != "1" ]]; then
    echo "Warning: Invalid Katex flag '$2'. Must be 0 or 1. Defaulting to 0."
    USE_KATEX=0
fi


# Create the directory structure if it doesn't exist
if [ ! -d "$POST_DIR" ]; then
    mkdir -p "$POST_DIR"
    echo "Created directory: $POST_DIR"
else
    echo "Directory already exists: $POST_DIR"
fi

# Check if the file already exists before writing
if [ -f "$FULL_PATH" ]; then
    echo "Warning: File already exists at $FULL_PATH. Skipping content creation."
else
    # Start writing the default front matter content
    cat << EOF > "$FULL_PATH"
---
date: $(date +%Y-%m-%d)
title: "Challenge: ${CHALLENGE_NAME}"
toc: true
description: "A writeup for the ${CHALLENGE_NAME} challenge."
---
EOF

    # Conditionally append the Katex shortcode if USE_KATEX is 1
    if [[ "$USE_KATEX" == "1" ]]; then
        echo -e "\n${KATEX_TAG}" >> "$FULL_PATH"
        echo "Added Katex shortcode."
    fi

    echo "Successfully created file: $FULL_PATH"
fi


echo "Opening file for modification..."
code "$FULL_PATH"

