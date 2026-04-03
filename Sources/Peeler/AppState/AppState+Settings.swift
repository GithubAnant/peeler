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
