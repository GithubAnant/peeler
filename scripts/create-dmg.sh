#!/usr/bin/env bash
#
# create-dmg.sh — Package Peeler.app into a beautifully styled DMG
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
DMG_TEMP="$PROJECT_ROOT/build/${APP_NAME}-temp.dmg"
STAGING_DIR="$PROJECT_ROOT/build/dmg-staging"
BG_DIR="$PROJECT_ROOT/build/dmg-background"

# DMG window dimensions
WIN_W=660
WIN_H=400
ICON_SIZE=128

# Icon positions (x, y) — centered vertically, spaced horizontally with room for arrow
APP_X=180
APP_Y=170
APPS_X=480
APPS_Y=170

# ── Validate ──────────────────────────────────────────────────────────────────

if [[ ! -d "$BUNDLE_DIR" ]]; then
    echo "ERROR: $BUNDLE_DIR not found."
    echo "       Run 'bash scripts/build-app.sh' first."
    exit 1
fi

# ── Generate DMG background image ────────────────────────────────────────────

echo "==> Generating DMG background image..."
mkdir -p "$BG_DIR"

# Create a styled background with a subtle gradient and arrow using Python/Pillow
# Falls back to a plain background if Pillow is not available
python3 -c "
import sys
try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    sys.exit(1)

W, H = ${WIN_W} * 2, ${WIN_H} * 2  # @2x for Retina
img = Image.new('RGBA', (W, H))
draw = ImageDraw.Draw(img)

# Whitish gradient background — light gray to white
for y in range(H):
    t = y / H
    r = int(245 + t * 10)
    g = int(245 + t * 10)
    b = int(250 + t * 5)
    draw.line([(0, y), (W, y)], fill=(r, g, b, 255))

# Subtle bottom strip - slightly darker
strip_h = int(H * 0.12)
for y in range(H - strip_h, H):
    t = (y - (H - strip_h)) / strip_h
    r = int(230 + t * 15)
    g = int(230 + t * 15)
    b = int(235 + t * 15)
    draw.line([(0, y), (W, y)], fill=(r, g, b, 255))

# Draw an arrow from app icon area to Applications icon area
# REMOVED - user doesn't want arrow

# Drag hint text
try:
    font = ImageFont.truetype('/System/Library/Fonts/Helvetica.ttc', 32)
except:
    font = ImageFont.load_default()

text = 'Drag to Applications'
bbox = draw.textbbox((0, 0), text, font=font)
tw = bbox[2] - bbox[0]
draw.text(((W - tw) // 2, H - strip_h + 25), text, fill=(100, 100, 110, 230), font=font)

img.save('${BG_DIR}/background.png')
print('Background generated with Pillow')
" 2>/dev/null && BG_GENERATED=true || BG_GENERATED=false

if [[ "$BG_GENERATED" != "true" ]]; then
    echo "    Pillow not available, generating background with sips..."
    # Create a simple solid dark background using sips
    # First create a tiny 1x1 image, then scale it up
    printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\x0cIDATx\x9cc\x18\x14\x18\x00\x00\x04\x00\x01\xf6\x178\xa8\x00\x00\x00\x00IEND\xaeB`\x82' > "$BG_DIR/background.png"
    sips -z $((WIN_H * 2)) $((WIN_W * 2)) "$BG_DIR/background.png" --out "$BG_DIR/background.png" > /dev/null 2>&1 || true
fi

BG_IMAGE="$BG_DIR/background.png"

# ── Stage DMG contents ────────────────────────────────────────────────────────

echo "==> Staging DMG contents..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

cp -R "$BUNDLE_DIR" "$STAGING_DIR/"
ln -s /Applications "$STAGING_DIR/Applications"

# Add background image inside a hidden folder
mkdir -p "$STAGING_DIR/.background"
if [[ -f "$BG_IMAGE" ]]; then
    cp "$BG_IMAGE" "$STAGING_DIR/.background/background.png"
fi

# ── Create temporary writable DMG ────────────────────────────────────────────

echo "==> Creating temporary DMG..."
rm -f "$DMG_TEMP"

# Calculate size — app size + generous padding
APP_SIZE_KB=$(du -sk "$BUNDLE_DIR" | awk '{print $1}')
DMG_SIZE_KB=$(( APP_SIZE_KB + 20480 ))  # +20MB padding

hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$STAGING_DIR" \
    -ov \
    -format UDRW \
    -size "${DMG_SIZE_KB}k" \
    "$DMG_TEMP"

# ── Mount and style the DMG ──────────────────────────────────────────────────

echo "==> Styling DMG window..."
MOUNT_DIR="/Volumes/$APP_NAME"

# Unmount if already mounted
hdiutil detach "$MOUNT_DIR" 2>/dev/null || true

hdiutil attach "$DMG_TEMP" -mountpoint "$MOUNT_DIR" -nobrowse -quiet

# Give Finder a moment to index
sleep 1

# Apply styling via AppleScript
osascript <<APPLESCRIPT
tell application "Finder"
    tell disk "$APP_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false

        -- Set window bounds: {x, y, x+w, y+h}
        set the bounds of container window to {100, 100, $((100 + WIN_W)), $((100 + WIN_H))}

        set theViewOptions to the icon view options of container window
        set arrangement of theViewOptions to not arranged
        set icon size of theViewOptions to $ICON_SIZE

        -- Set background image if it exists
        try
            set background picture of theViewOptions to file ".background:background.png"
        end try

        -- Position icons
        set position of item "${APP_NAME}.app" of container window to {$APP_X, $APP_Y}
        set position of item "Applications" of container window to {$APPS_X, $APPS_Y}

        -- Hide background folder from view
        try
            set position of item ".background" of container window to {900, 900}
        end try

        close
        open

        update without registering applications

        delay 2
        close
    end tell
end tell
APPLESCRIPT

# Ensure .background and .DS_Store persist
sync

# Unmount
sleep 1
hdiutil detach "$MOUNT_DIR" -quiet

# ── Convert to compressed read-only DMG ──────────────────────────────────────

echo "==> Compressing final DMG..."
rm -f "$DMG_PATH"

hdiutil convert \
    "$DMG_TEMP" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$DMG_PATH"

# ── Cleanup ───────────────────────────────────────────────────────────────────

rm -f "$DMG_TEMP"
rm -rf "$STAGING_DIR"
rm -rf "$BG_DIR"

echo ""
echo "==> DMG created: $DMG_PATH"
echo ""
echo "    Opens with a styled window — users drag Peeler.app to Applications."
echo ""
echo "    If macOS says the app is damaged or unverified after install, tell users to run:"
echo "      xattr -rd com.apple.quarantine /Applications/${APP_NAME}.app"
echo ""
