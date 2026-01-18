#!/bin/bash

# Usage: ./get_changes.sh [path]
TARGET_PATH=${1:-"."}

# Get the latest tag
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)

echo "Target path: $TARGET_PATH"

if [ -z "$LATEST_TAG" ]; then
    echo "No tags found. Showing all commits for $TARGET_PATH."
    git log --pretty=format:"- %s (%h)" -- "$TARGET_PATH"
else
    echo "Changes since $LATEST_TAG in $TARGET_PATH:"
    git log "${LATEST_TAG}..HEAD" --pretty=format:"- %s (%h)" -- "$TARGET_PATH"
fi
