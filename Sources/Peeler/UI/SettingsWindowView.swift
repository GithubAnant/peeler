import SwiftUI

struct SettingsWindowView: View {
    @EnvironmentObject var appState: AppState
    @State private var selection: SettingsPane = .general

    var body: some View {
        NavigationSplitView {
            SettingsSidebar(selection: $selection)
        } detail: {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        Text(selection.title)
                            .font(.system(size: 28, weight: .semibold))
                        Spacer()
                        Button("Quit App") {
                            NSApp.terminate(nil)
                        }
                    }

                    switch selection {
                    case .general:
                        GeneralSettingsSection(
                            preferredFormat: preferredFormatBinding,
                            paletteCount: paletteCountBinding,
                            launchAtLogin: launchAtLoginBinding,
                            playSound: playSoundBinding,
                            currentPaletteCount: appState.settings.paletteColorCount
                        )
                    case .hotkeys:
                        HotkeySettingsSection(
                            eyedropperHotkey: appState.settings.eyedropperHotkey,
                            paletteHotkey: appState.settings.paletteHotkey,
                            onEyedropperChange: { appState.setHotKey($0, for: .eyedropper) },
                            onPaletteChange: { appState.setHotKey($0, for: .palette) },
                            conflictMessage: appState.hotKeyConflictMessage
                        )
                    case .appearance:
                        AppearanceSettingsSection(
                            theme: themeBinding,
                            panelPosition: panelPositionBinding
                        )
                    case .about:
                        AboutSettingsSection()
                    }
                }
                .padding(28)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .background(Color(nsColor: .windowBackgroundColor))
        }
        .navigationSplitViewStyle(.balanced)
    }
}
