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
    let metadata: AppMetadata
    @ObservedObject var updater: AppUpdateController

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            GroupCard("About Peeler") {
                HStack(spacing: 14) {
                    BrandBadgeView()

                    VStack(alignment: .leading, spacing: 6) {
                        Text(metadata.displayName)
                            .font(.system(size: 18, weight: .semibold))

                        if let releaseName = metadata.releaseName, !releaseName.isEmpty {
                            Text(releaseName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.secondary)
                        }

                        Text("Version \(metadata.versionDescription)")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }
            }

            GroupCard("Version Info") {
                SettingsInfoRow(label: "App", value: metadata.appName)
                Divider().overlay(Color.white.opacity(0.05))
                SettingsInfoRow(label: "Version", value: metadata.version)
                Divider().overlay(Color.white.opacity(0.05))
                SettingsInfoRow(label: "Build", value: metadata.build)
                Divider().overlay(Color.white.opacity(0.05))
                SettingsInfoRow(label: "Bundle ID", value: metadata.bundleIdentifier)
                Divider().overlay(Color.white.opacity(0.05))
                SettingsInfoRow(label: "Minimum macOS", value: metadata.minimumSystemVersion)
                Divider().overlay(Color.white.opacity(0.05))
                SettingsInfoRow(label: "Installed At", value: metadata.installPath)
            }

            GroupCard("Software Updates") {
                SettingsInfoRow(label: "Status", value: updater.statusDescription)
                Divider().overlay(Color.white.opacity(0.05))
                SettingsInfoRow(label: "Appcast Feed", value: metadata.updateFeedURL?.absoluteString ?? "Not configured")
                Divider().overlay(Color.white.opacity(0.05))
                SettingsToggleRow(
                    title: "Automatically check for updates",
                    isOn: Binding(
                        get: { updater.automaticallyChecksForUpdates },
                        set: { updater.setAutomaticallyChecksForUpdates($0) }
                    )
                )
                .disabled(!updater.isConfigured)
                Divider().overlay(Color.white.opacity(0.05))
                SettingsToggleRow(
                    title: "Automatically download updates",
                    isOn: Binding(
                        get: { updater.automaticallyDownloadsUpdates },
                        set: { updater.setAutomaticallyDownloadsUpdates($0) }
                    )
                )
                .disabled(!updater.isConfigured || !updater.automaticallyChecksForUpdates)
            }

            GroupCard("Links") {
                if let homepageURL = metadata.homepageURL {
                    SettingsLinkRow(title: "Website", url: homepageURL)
                    if metadata.repositoryURL != nil || metadata.authorURL != nil {
                        Divider().overlay(Color.white.opacity(0.05))
                    }
                }

                if let repositoryURL = metadata.repositoryURL {
                    SettingsLinkRow(title: "Repository", url: repositoryURL)
                    if metadata.authorURL != nil {
                        Divider().overlay(Color.white.opacity(0.05))
                    }
                }

                if let authorURL = metadata.authorURL {
                    SettingsLinkRow(
                        title: metadata.authorName.map { "Author (\($0))" } ?? "Author",
                        url: authorURL
                    )
                }
            }

            Spacer(minLength: 0)

            if let copyright = metadata.copyright {
                Text(copyright)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
            }
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
                .multilineTextAlignment(.trailing)
                .textSelection(.enabled)
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

private struct SettingsLinkRow: View {
    let title: String
    let url: URL

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
            Spacer()
            Button(url.absoluteString) {
                NSWorkspace.shared.open(url)
            }
            .buttonStyle(.plain)
            .font(.system(size: 13))
            .foregroundStyle(.secondary)
            .underline()
        }
    }
}
