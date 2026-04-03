#!/usr/bin/env bash
#
# generate-appcast.sh — Generate Sparkle appcast.xml for packaged updates
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
UPDATES_DIR="${1:-$PROJECT_ROOT/build/updates}"

if [[ ! -d "$UPDATES_DIR" ]]; then
    echo "ERROR: Updates directory not found at $UPDATES_DIR"
    echo "       Run 'bash scripts/create-update-archive.sh' first."
    exit 1
fi

if command -v generate_appcast >/dev/null 2>&1; then
    GENERATE_APPCAST_BIN="$(command -v generate_appcast)"
elif [[ -n "${SPARKLE_BIN_DIR:-}" && -x "${SPARKLE_BIN_DIR}/generate_appcast" ]]; then
    GENERATE_APPCAST_BIN="${SPARKLE_BIN_DIR}/generate_appcast"
else
    echo "ERROR: Sparkle's generate_appcast tool was not found."
    echo "       Install Sparkle's CLI tools or set SPARKLE_BIN_DIR to the folder containing generate_appcast."
    exit 1
fi

echo "==> Generating Sparkle appcast in $UPDATES_DIR..."
"$GENERATE_APPCAST_BIN" "$UPDATES_DIR"

echo ""
echo "==> Appcast generated."
echo "    Publish appcast.xml alongside your ZIP archives at the SUFeedURL location."
