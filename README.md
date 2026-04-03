# Peeler

A lightweight macOS menu bar app for picking colors and extracting palettes from your screen.

## Features

- **Eyedropper** — Pick any color from your screen with a global hotkey
- **Palette extraction** — Select a screen region and extract its dominant colors
- **12 color formats** — Copy as Hex, RGB, HSL, HSB, OKLCH, SwiftUI, NSColor, UIColor, and more
- **Color history** — Browse and re-copy recently picked colors
- **Saved palettes** — Name, organize, and revisit extracted palettes
- **Export** — Export palettes as CSS variables, Tailwind config, JSON, or plain hex

## Requirements

- macOS 13.0+
- Screen Recording permission (the app will prompt you on first use)

## Install

Download the latest DMG from the [Releases](https://github.com/anantsinghal/peeler/releases) page, open it, and drag **Peeler.app** to your Applications folder.

Since Peeler is not notarized, macOS may block it on first launch. To fix this, run:

```bash
xattr -rd com.apple.quarantine /Applications/Peeler.app
```

Then open the app normally.

## Hotkeys

| Action | Shortcut |
|--------|----------|
| Pick a color | `Cmd + Shift + C` |
| Extract palette | `Cmd + Shift + X` |

Right-click the menu bar icon for History, Palettes, Settings, and Quit.

## Build from Source

Requires Xcode 15+ and Swift 6.0.

```bash
# Run in debug mode
swift run

# Build the .app bundle
bash scripts/build-app.sh

# Package into a DMG
bash scripts/create-dmg.sh
```

Build output goes to `build/Peeler.app` and `build/Peeler-1.0.0.dmg`.

### App icon

Drop a 1024x1024 PNG at `Sources/Peeler/Resources/Brand/app-icon.png` before building. The build script converts it to `.icns` automatically. Without it, the app uses a generic macOS icon.

## License

[MIT](LICENSE)
