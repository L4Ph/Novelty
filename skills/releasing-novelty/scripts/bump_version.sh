#!/bin/bash

BUMP_TYPE=$1
FILE=${2:-"pubspec.yaml"}

if [ -z "$BUMP_TYPE" ]; then
    echo "Usage: $0 [major|minor|patch|build] [file_path]"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found"
    exit 1
fi

# Extract current version line: "version: 0.13.0+105"
VERSION_LINE=$(grep "^version: " "$FILE")
CURRENT_VERSION=$(echo "$VERSION_LINE" | sed 's/version: //')

if [ -z "$CURRENT_VERSION" ]; then
    echo "Error: Could not find 'version:' in $FILE"
    exit 1
fi

# Parse version (x.y.z+build)
# Remove build part for semantic versioning
SEMVER=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

# If no build number exists (e.g. 0.1.0), default to 0 for logic, but might be empty string
if [ "$SEMVER" == "$CURRENT_VERSION" ]; then
    HAS_BUILD_NUMBER=false
    BUILD=0
else
    HAS_BUILD_NUMBER=true
fi

# Split SEMVER into array
IFS='.' read -r -a PARTS <<< "$SEMVER"
MAJOR=${PARTS[0]}
MINOR=${PARTS[1]}
PATCH=${PARTS[2]}

case $BUMP_TYPE in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    build)
        # Just bump build number
        if [ "$HAS_BUILD_NUMBER" = false ]; then
             echo "Warning: No build number found in current version, starting at +1"
        fi
        ;;
    *)
        echo "Invalid bump type: $BUMP_TYPE"
        echo "Usage: $0 [major|minor|patch|build] [file_path]"
        exit 1
        ;;
esac

# Bump build number logic
NEW_BUILD=$((BUILD + 1))

if [[ "$FILE" == *"packages"* ]]; then
    # Package versioning usually doesn't need build number (x.y.z) unless strictly required
    # But if the user asked for 'build' bump, we must add it.
    # If standard semantic versioning (no build number previously), keep it that way unless explicit build bump?
    # Let's stick to standard semver x.y.z for packages if they didn't have a build number.
    if [ "$HAS_BUILD_NUMBER" = true ] || [ "$BUMP_TYPE" == "build" ]; then
        NEW_VERSION="$MAJOR.$MINOR.$PATCH+$NEW_BUILD"
    else
        NEW_VERSION="$MAJOR.$MINOR.$PATCH"
    fi
else
    # App version usually has build number
    NEW_VERSION="$MAJOR.$MINOR.$PATCH+$NEW_BUILD"
fi

# Replace in file
# Use a temp file to avoid sed issues with permission/inplace on some systems, though -i is fine on linux
# ensuring we only replace the first occurrence of version: at start of line
sed -i "0,/^version: .*/s//version: $NEW_VERSION/" "$FILE"

echo "Version bumped from $CURRENT_VERSION to $NEW_VERSION in $FILE"
