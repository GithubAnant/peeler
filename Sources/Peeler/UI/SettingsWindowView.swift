import SwiftUI

struct SettingsWindowView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NativeWindowShell("Settings") {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    GeneralSettingsSection(
                        preferredFormat: preferredFormatBinding,
                        paletteCount: paletteCountBinding,
                        launchAtLogin: launchAtLoginBinding,
                        playSound: playSoundBinding,
                        currentPaletteCount: appState.settings.paletteColorCount
                    )

                    HotkeySettingsSection(
                        eyedropperHotkey: appState.settings.eyedropperHotkey.displayString,
                        paletteHotkey: appState.settings.paletteHotkey.displayString
                    )

                    AppearanceSettingsSection(
                        theme: themeBinding,
                        panelPosition: panelPositionBinding
                    )

                    AboutSettingsSection()
                }
            }
        }
    }
}
