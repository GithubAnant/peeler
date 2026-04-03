import AppKit

extension AppState {
    func updateSettings(_ mutate: (inout AppSettings) -> Void) {
        var copy = settings
        mutate(&copy)
        copy.normalize()
        settings = copy
        persistence.saveSettings(copy)
    }

    func setSelectedTab(_ tab: PanelTab) {
        updateSettings { $0.lastActiveTab = tab }
    }

    func showPermissionAlert() {
        permissionAlertVisible = true
    }

    func setHotKey(_ combination: HotKeyCombination, for kind: HotKeyKind) {
        switch kind {
        case .eyedropper:
            updateSettings { $0.eyedropperHotkey = combination }
        case .palette:
            updateSettings { $0.paletteHotkey = combination }
        }

        onHotKeySettingsChanged?()
    }

    func hotKey(for kind: HotKeyKind) -> HotKeyCombination {
        switch kind {
        case .eyedropper:
            settings.eyedropperHotkey
        case .palette:
            settings.paletteHotkey
        }
    }

    func applyTheme(_ theme: AppTheme) {
        updateSettings { $0.theme = theme }

        switch theme {
        case .system:
            NSApp.appearance = nil
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        }
    }
}
