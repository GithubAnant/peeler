#!/usr/bin/env bash
#
# build-app.sh — Build Peeler.app bundle from Swift Package Manager output
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

APP_NAME="Peeler"
BUNDLE_DIR="$PROJECT_ROOT/build/${APP_NAME}.app"
CONTENTS_DIR="$BUNDLE_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

RESOURCES_SRC="$PROJECT_ROOT/Sources/Peeler/Resources"
ICON_PNG="$RESOURCES_SRC/Brand/app-icon.png"
ICONSET_DIR="$PROJECT_ROOT/build/AppIcon.iconset"

echo "==> Building $APP_NAME release binary..."
cd "$PROJECT_ROOT"
swift build -c release

# Locate the built binary
BINARY="$(swift build -c release --show-bin-path)/$APP_NAME"
if [[ ! -f "$BINARY" ]]; then
    echo "ERROR: Binary not found at $BINARY"
    exit 1
fi
echo "    Binary: $BINARY"

# ── Create .app bundle structure ──────────────────────────────────────────────

echo "==> Creating .app bundle..."
rm -rf "$BUNDLE_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

# Copy binary
cp "$BINARY" "$MACOS_DIR/$APP_NAME"
chmod +x "$MACOS_DIR/$APP_NAME"

# Copy Info.plist
cp "$RESOURCES_SRC/Info.plist" "$CONTENTS_DIR/Info.plist"

# Copy SPM-bundled resources (the _Resources bundle that SPM generates)
SPM_RESOURCES="$(swift build -c release --show-bin-path)/Peeler_Peeler.bundle"
if [[ -d "$SPM_RESOURCES" ]]; then
    echo "    Copying SPM resource bundle..."
    cp -R "$SPM_RESOURCES" "$RESOURCES_DIR/"
fi

# ── Convert app-icon.png → AppIcon.icns ──────────────────────────────────────

if [[ -f "$ICON_PNG" ]]; then
    echo "==> Converting app-icon.png to AppIcon.icns..."
    rm -rf "$ICONSET_DIR"
    mkdir -p "$ICONSET_DIR"

    # Generate all required icon sizes using sips
    for SIZE in 16 32 64 128 256 512; do
        sips -z $SIZE $SIZE "$ICON_PNG" --out "$ICONSET_DIR/icon_${SIZE}x${SIZE}.png" > /dev/null 2>&1
    done
    # Retina variants (@2x)
    for SIZE in 32 64 256 512 1024; do
        HALF=$((SIZE / 2))
        sips -z $SIZE $SIZE "$ICON_PNG" --out "$ICONSET_DIR/icon_${HALF}x${HALF}@2x.png" > /dev/null 2>&1
    done

    iconutil -c icns "$ICONSET_DIR" -o "$RESOURCES_DIR/AppIcon.icns"
    rm -rf "$ICONSET_DIR"
    echo "    AppIcon.icns created."
else
    echo "    WARN: No app-icon.png found at $ICON_PNG — skipping icon generation."
    echo "          The app will use a generic macOS icon."
fi

# Copy the brand PNG into the bundle too (used by BrandBadgeView at runtime)
if [[ -f "$ICON_PNG" ]]; then
    mkdir -p "$RESOURCES_DIR/Brand"
    cp "$ICON_PNG" "$RESOURCES_DIR/Brand/app-icon.png"
fi

# ── Ad-hoc code signing ──────────────────────────────────────────────────────

echo "==> Ad-hoc code signing..."
codesign --force --deep -s - \
    --entitlements "$RESOURCES_SRC/Peeler.entitlements" \
    "$BUNDLE_DIR"
echo "    Signed with ad-hoc identity."

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo "==> Build complete: $BUNDLE_DIR"
echo ""
echo "    To run:  open $BUNDLE_DIR"
echo ""
echo "    If macOS says the app is damaged or unverified, run:"
echo "      xattr -rd com.apple.quarantine $BUNDLE_DIR"
