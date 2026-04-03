import AppKit

extension AppState {
    func handlePickedColor(_ color: NSColor, shouldCopy: Bool = true) {
        let token = ColorToken(hex: ColorComponents(color).hex)
        currentColor = token
        recentColors.removeAll(where: { $0.hex.caseInsensitiveCompare(token.hex) == .orderedSame })
        recentColors.insert(token, at: 0)
        recentColors = Array(recentColors.prefix(50))
        persistence.saveRecentColors(recentColors)

        if shouldCopy {
            copy(colorHex: token.hex, format: settings.preferredFormat)
        }
    }

    func selectRecentColor(_ token: ColorToken) {
        currentColor = token
        copy(colorHex: token.hex, format: settings.preferredFormat)
    }

    func removeRecentColor(_ token: ColorToken) {
        recentColors.removeAll(where: { $0.id == token.id })
        persistence.saveRecentColors(recentColors)
        if currentColor?.id == token.id {
            currentColor = recentColors.first
        }
    }

    func copyCurrentColor(as format: CopyFormat? = nil) {
        guard let currentColor else { return }
        copy(colorHex: currentColor.hex, format: format ?? settings.preferredFormat)
    }

    func copy(colorHex: String, format: CopyFormat) {
        guard let color = ColorParser.nsColor(from: colorHex) else { return }
        let value = ColorFormatter.string(for: color, format: format)
        clipboard.copy(string: value)

        if settings.playCopySound {
            NSSound(named: "Glass")?.play()
        }

        presentHUD?(HUDPayload(colorHex: colorHex, format: format, copiedValue: value))
    }
}
