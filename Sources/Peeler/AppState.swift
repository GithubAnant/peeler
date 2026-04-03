import AppKit
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var settings: AppSettings
    @Published var recentColors: [ColorToken]
    @Published var activePalette: PaletteRecord?
    @Published var paletteHistory: [PaletteRecord]
    @Published var currentColor: ColorToken?
    @Published var permissionAlertVisible = false
    @Published var hotKeyConflictMessage: String?

    var triggerEyedropper: (() -> Void)?
    var triggerPaletteCapture: (() -> Void)?
    var openSettingsWindow: (() -> Void)?
    var openHistoryWindow: (() -> Void)?
    var openSavedPalettesWindow: (() -> Void)?
    var openPrivacySettings: (() -> Void)?
    var presentHUD: ((HUDPayload) -> Void)?

    let clipboard = ClipboardService()
    let persistence = PersistenceController()

    init() {
        settings = persistence.loadSettings()
        recentColors = persistence.loadRecentColors()
        paletteHistory = persistence.loadPalettes()
        currentColor = recentColors.first
        activePalette = paletteHistory.first
    }

    var savedPalettes: [PaletteRecord] {
        paletteHistory.filter(\.isSaved)
    }

    var currentColorValue: String {
        guard let currentColor else {
            return "Pick a color to get started"
        }
        return ColorFormatter.string(for: currentColor.nsColor, format: settings.preferredFormat)
    }
}
