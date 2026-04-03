#!/usr/bin/env bash
#
# create-update-archive.sh — Package Peeler.app into a Sparkle-compatible ZIP
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

APP_NAME="Peeler"
INFO_PLIST="$PROJECT_ROOT/Sources/Peeler/Resources/Info.plist"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$INFO_PLIST")"
BUNDLE_DIR="$PROJECT_ROOT/build/${APP_NAME}.app"
UPDATES_DIR="$PROJECT_ROOT/build/updates"
ARCHIVE_PATH="$UPDATES_DIR/${APP_NAME}-${VERSION}.zip"

if [[ ! -d "$BUNDLE_DIR" ]]; then
    echo "ERROR: $BUNDLE_DIR not found."
    echo "       Run 'bash scripts/build-app.sh' first."
    exit 1
fi

mkdir -p "$UPDATES_DIR"
rm -f "$ARCHIVE_PATH"

echo "==> Creating Sparkle archive..."
ditto -c -k --sequesterRsrc --keepParent "$BUNDLE_DIR" "$ARCHIVE_PATH"

echo ""
echo "==> Update archive created: $ARCHIVE_PATH"
echo ""
echo "    Upload this ZIP and the generated appcast.xml to your release host."
