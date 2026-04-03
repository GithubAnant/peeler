import AppKit
import SwiftUI

struct GeneralSettingsSection: View {
    @Binding var preferredFormat: CopyFormat
    @Binding var paletteCount: Int
    @Binding var launchAtLogin: Bool
    @Binding var playSound: Bool
    let currentPaletteCount: Int

    var body: some View {
        GroupCard("General") {
            Picker("Default copy format", selection: $preferredFormat) {
                ForEach(CopyFormat.allCases) { format in
                    Text(format.menuTitle).tag(format)
                }
            }

            Stepper(value: $paletteCount, in: 4...10) {
                HStack {
                    Text("Number of palette colors")
                    Spacer()
                    Text("\(currentPaletteCount)")
                        .foregroundStyle(.secondary)
                }
            }

            Toggle("Launch at login", isOn: $launchAtLogin)
            Toggle("Play sound on copy", isOn: $playSound)
        }
    }
}

struct HotkeySettingsSection: View {
    let eyedropperHotkey: String
    let paletteHotkey: String

    var body: some View {
        GroupCard("Hotkeys") {
            LabeledContent("Eyedropper hotkey") {
                Text(eyedropperHotkey)
                    .font(.system(.body, design: .monospaced))
            }
            LabeledContent("Screenshot palette hotkey") {
                Text(paletteHotkey)
                    .font(.system(.body, design: .monospaced))
            }

            Text("Hotkey recording UI is left intentionally simple in this first pass. The defaults are wired and conflicts surface when registration fails.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct AppearanceSettingsSection: View {
    @Binding var theme: AppTheme
    @Binding var panelPosition: PanelPlacement

    var body: some View {
        GroupCard("Appearance") {
            Picker("Color theme", selection: $theme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }

            Picker("Panel position", selection: $panelPosition) {
                ForEach(PanelPlacement.allCases) { placement in
                    Text(placement.title).tag(placement)
                }
            }
        }
    }
}

struct AboutSettingsSection: View {
    var body: some View {
        GroupCard("About and Updates") {
            HStack(spacing: 12) {
                BrandBadgeView()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Peeler")
                        .font(.headline)
                    Text("Version 1.0 concept build")
                        .foregroundStyle(.secondary)
                    Text("Add `Sources/Peeler/Resources/Brand/app-icon.png` to replace the placeholder badge.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Button("Check for Updates") {}
            Button("Support on GitHub") {
                guard let url = URL(string: "https://github.com/sponsors") else { return }
                NSWorkspace.shared.open(url)
            }
        }
    }
}
