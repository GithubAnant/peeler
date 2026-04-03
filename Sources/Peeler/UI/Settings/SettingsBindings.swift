import SwiftUI

extension SettingsWindowView {
    var preferredFormatBinding: Binding<CopyFormat> {
        Binding(
            get: { appState.settings.preferredFormat },
            set: { value in
                appState.updateSettings { $0.preferredFormat = value }
            }
        )
    }

    var paletteCountBinding: Binding<Int> {
        Binding(
            get: { appState.settings.paletteColorCount },
            set: { value in
                appState.updateSettings { $0.paletteColorCount = value }
            }
        )
    }

    var launchAtLoginBinding: Binding<Bool> {
        Binding(
            get: { appState.settings.launchAtLogin },
            set: { value in
                appState.updateSettings { $0.launchAtLogin = value }
            }
        )
    }

    var playSoundBinding: Binding<Bool> {
        Binding(
            get: { appState.settings.playCopySound },
            set: { value in
                appState.updateSettings { $0.playCopySound = value }
            }
        )
    }

    var automaticallyCheckUpdatesBinding: Binding<Bool> {
        Binding(
            get: { appState.settings.automaticallyCheckUpdates },
            set: { value in
                appState.updateSettings { $0.automaticallyCheckUpdates = value }
            }
        )
    }

    var automaticallyDownloadUpdatesBinding: Binding<Bool> {
        Binding(
            get: { appState.settings.automaticallyDownloadUpdates },
            set: { value in
                appState.updateSettings { $0.automaticallyDownloadUpdates = value }
            }
        )
    }

    var themeBinding: Binding<AppTheme> {
        Binding(
            get: { appState.settings.theme },
            set: { value in
                appState.applyTheme(value)
            }
        )
    }

    var panelPositionBinding: Binding<PanelPlacement> {
        Binding(
            get: { appState.settings.panelPosition },
            set: { value in
                appState.updateSettings { $0.panelPosition = value }
            }
        )
    }
}
