import AppKit
import Combine
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

    let appMetadata: AppMetadata
    let updater: AppUpdateController

    var triggerEyedropper: (() -> Void)?
    var triggerPaletteCapture: (() -> Void)?
    var openSettingsWindow: (() -> Void)?
    var openHistoryWindow: (() -> Void)?
    var openSavedPalettesWindow: (() -> Void)?
    var openPrivacySettings: (() -> Void)?
    var presentHUD: ((HUDPayload) -> Void)?
    var onHotKeySettingsChanged: (() -> Void)?

    let clipboard: ClipboardService
    let persistence: PersistenceController

    init(
        appMetadata: AppMetadata = .current(),
        updater: AppUpdateController = AppUpdateController()
    ) {
        self.appMetadata = appMetadata
        self.updater = updater
        self.clipboard = ClipboardService()
        self.persistence = PersistenceController()
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
