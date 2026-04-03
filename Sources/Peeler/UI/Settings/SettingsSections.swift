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
    let eyedropperHotkey: HotKeyCombination
    let paletteHotkey: HotKeyCombination
    let onEyedropperChange: (HotKeyCombination) -> Void
    let onPaletteChange: (HotKeyCombination) -> Void
    let conflictMessage: String?

    var body: some View {
        GroupCard("Hotkeys") {
            LabeledContent("Eyedropper hotkey") {
                HotKeyRecorderField(
                    title: "Click and press a shortcut",
                    combination: eyedropperHotkey,
                    onCommit: onEyedropperChange
                )
                .frame(width: 220)
            }
            LabeledContent("Screenshot palette hotkey") {
                HotKeyRecorderField(
                    title: "Click and press a shortcut",
                    combination: paletteHotkey,
                    onCommit: onPaletteChange
                )
                .frame(width: 220)
            }

            Text("Click a field, press a modifier shortcut, and it takes effect immediately.")
                .font(.caption)
                .foregroundStyle(.secondary)

            if let conflictMessage {
                Text(conflictMessage)
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
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
    private var versionString: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    var body: some View {
        GroupCard("About and Updates") {
            HStack(spacing: 12) {
                BrandBadgeView()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Peeler")
                        .font(.headline)
                    Text(versionString)
                        .foregroundStyle(.secondary)
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
