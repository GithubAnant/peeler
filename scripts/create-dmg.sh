#!/usr/bin/env bash
#
# create-dmg.sh — Package Peeler.app into a distributable DMG
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

APP_NAME="Peeler"
INFO_PLIST="$PROJECT_ROOT/Sources/Peeler/Resources/Info.plist"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$INFO_PLIST")"
BUNDLE_DIR="$PROJECT_ROOT/build/${APP_NAME}.app"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
DMG_PATH="$PROJECT_ROOT/build/$DMG_NAME"
STAGING_DIR="$PROJECT_ROOT/build/dmg-staging"

# ── Validate ──────────────────────────────────────────────────────────────────

if [[ ! -d "$BUNDLE_DIR" ]]; then
    echo "ERROR: $BUNDLE_DIR not found."
    echo "       Run 'bash scripts/build-app.sh' first."
    exit 1
fi

# ── Stage DMG contents ────────────────────────────────────────────────────────

echo "==> Staging DMG contents..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

cp -R "$BUNDLE_DIR" "$STAGING_DIR/"
ln -s /Applications "$STAGING_DIR/Applications"

# ── Create DMG ────────────────────────────────────────────────────────────────

echo "==> Creating $DMG_NAME..."
rm -f "$DMG_PATH"

hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$STAGING_DIR" \
    -ov \
    -format UDZO \
    "$DMG_PATH"

# ── Cleanup ───────────────────────────────────────────────────────────────────

rm -rf "$STAGING_DIR"

echo ""
echo "==> DMG created: $DMG_PATH"
echo ""
echo "    Users can drag Peeler.app to their Applications folder."
echo ""
echo "    If macOS says the app is damaged or unverified after install, tell users to run:"
echo "      xattr -rd com.apple.quarantine /Applications/${APP_NAME}.app"
