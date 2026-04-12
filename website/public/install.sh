#!/usr/bin/env bash

set -e

echo "=> Fetching latest Peeler release..."

# Get the latest release zip
LATEST_URL=$(curl -s https://api.github.com/repos/GithubAnant/peeler/releases/latest | grep "browser_download_url.*zip" | cut -d '"' -f 4 | head -n 1)

if [ -z "$LATEST_URL" ]; then
    echo "Error: Could not find the latest release zip."
    echo "Make sure there are published releases on the GithubAnant/peeler repository."
    exit 1
fi

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "=> Downloading from $LATEST_URL..."
curl -fsSL -o Peeler.zip "$LATEST_URL"

echo "=> Extracting Peeler..."
unzip -q Peeler.zip

echo "=> Installing to /Applications..."
if [ -d "/Applications/Peeler.app" ]; then
    rm -rf "/Applications/Peeler.app"
fi
mv Peeler.app /Applications/

echo "=> Removing quarantine attribute so macOS doesn't block it..."
xattr -rd com.apple.quarantine /Applications/Peeler.app || true

echo "=> Cleaning up..."
cd /
rm -rf "$TEMP_DIR"

echo ""
echo "✨ Peeler installed successfully! You can find it in your Applications folder."
