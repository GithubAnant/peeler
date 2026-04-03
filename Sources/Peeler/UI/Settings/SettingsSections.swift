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
        .controlSize(.small)
        .font(.system(size: 13))
    }
}

struct HotkeySettingsSection: View {
    let eyedropperHotkey: HotKeyCombination
    let paletteHotkey: HotKeyCombination
    let onEyedropperChange: (HotKeyCombination) -> Void
    let onPaletteChange: (HotKeyCombination) -> Void
    let conflictMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hotkeys")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .padding(.horizontal, 2)

            HotkeyCard(
                label: "Eyedropper:",
                combination: eyedropperHotkey,
                defaultCombination: .eyedropperDefault,
                onChange: onEyedropperChange
            )

            HotkeyCard(
                label: "Screenshot Palette:",
                combination: paletteHotkey,
                defaultCombination: .paletteDefault,
                onChange: onPaletteChange
            )

            if let conflictMessage {
                HStack(spacing: 5) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 10))
                    Text(conflictMessage)
                }
                .font(.caption)
                .foregroundStyle(.orange)
                .padding(.horizontal, 2)
            }
        }
    }
}

private struct HotkeyCard: View {
    let label: String
    let combination: HotKeyCombination
    let defaultCombination: HotKeyCombination
    let onChange: (HotKeyCombination) -> Void

    private let shape = RoundedRectangle(cornerRadius: 12, style: .continuous)

    var body: some View {
        HStack(spacing: 0) {
            Text(label)
                .font(.system(size: 14, weight: .medium))

            Spacer()

            HStack(spacing: 6) {
                HotKeyRecorderField(
                    title: "Record shortcut",
                    combination: combination,
                    onCommit: onChange
                )
                .fixedSize()

                Button {
                    onChange(defaultCombination)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help("Reset to default")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            shape
                .fill(Color.white.opacity(0.045))
        )
        .clipShape(shape)
        .overlay(
            shape
                .strokeBorder(Color.white.opacity(0.035), lineWidth: 0.75)
        )
    }
}

struct AppearanceSettingsSection: View {
    @Binding var theme: AppTheme
    @Binding var panelPosition: PanelPlacement

    var body: some View {
        GroupCard("Appearance") {
            HStack {
                Text("Color theme")
                    .font(.system(size: 13))
                Spacer()
                Picker("", selection: $theme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.title).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .fixedSize()
            }

            Divider().opacity(0.4)

            HStack {
                Text("Panel position")
                    .font(.system(size: 13))
                Spacer()
                Picker("", selection: $panelPosition) {
                    ForEach(PanelPlacement.allCases) { placement in
                        Text(placement.title).tag(placement)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .fixedSize()
            }
        }
        .controlSize(.small)
        .font(.system(size: 13))
    }
}

struct AboutSettingsSection: View {
    @Binding var automaticallyCheckUpdates: Bool
    @Binding var automaticallyDownloadUpdates: Bool

    private var versionString: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    private var releaseName: String {
        "Flying Rabbit"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            GroupCard("Version Info") {
                SettingsInfoRow(label: "Release name", value: "\(releaseName)  🐇")
                Divider().overlay(Color.white.opacity(0.05))
                SettingsInfoRow(label: "Version", value: versionString.replacingOccurrences(of: "Version ", with: ""))
            }

            GroupCard("Software Updates") {
                SettingsToggleRow(title: "Automatically check for updates", isOn: $automaticallyCheckUpdates)
                Divider().overlay(Color.white.opacity(0.05))
                SettingsToggleRow(title: "Automatically download updates", isOn: $automaticallyDownloadUpdates)
            }

            Button {
                guard let url = URL(string: "https://github.com/sponsors") else { return }
                NSWorkspace.shared.open(url)
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "chevron.left.forwardslash.chevron.right")
                        .font(.system(size: 26, weight: .semibold))
                    Text("GitHub")
                        .font(.system(size: 18, weight: .medium))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 26)
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.045))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.035), lineWidth: 0.75)
            )

            Spacer(minLength: 0)

            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Text("Made with 🫶 by")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    Button("anant singhal") {
                        guard let url = URL(string: "https://anants.studio") else { return }
                        NSWorkspace.shared.open(url)
                    }
                    .buttonStyle(.plain)
                    .font(.system(size: 12))
                    .underline()
                    .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}

private struct SettingsInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
            Spacer()
            Text(value)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
    }
}

private struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, weight: .medium))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .controlSize(.small)
        }
    }
}
