import SwiftUI

struct EyedropperTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 12) {
            GroupCard {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(nsColor: appState.currentColor?.nsColor ?? NSColor(calibratedWhite: 0.34, alpha: 1)))
                    .frame(height: 104)
                    .overlay(alignment: .bottomLeading) {
                        if appState.currentColor == nil {
                            Text("Pick a color to get started")
                                .font(.callout)
                                .foregroundStyle(.white.opacity(0.9))
                                .padding(14)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 6) {
                    Text(appState.settings.preferredFormat.shortLabel)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Text(appState.currentColorValue)
                        .font(.system(size: 16, weight: .medium, design: .monospaced))
                        .textSelection(.enabled)
                        .lineLimit(2)
                }
            }

            GroupCard("Formats") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(CopyFormat.allCases) { format in
                            Button {
                                appState.updateSettings { $0.preferredFormat = format }
                                appState.copyCurrentColor(as: format)
                            } label: {
                                Text(format.shortLabel)
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule(style: .continuous)
                                            .fill(appState.settings.preferredFormat == format ? Color.accentColor.opacity(0.2) : Color.white.opacity(0.06))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Button {
                    appState.triggerEyedropper?()
                } label: {
                    Label("Pick Color", systemImage: "eyedropper")
                        .frame(maxWidth: .infinity)
                }
                .keyboardShortcut(.return, modifiers: [])
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }

            GroupCard("Recent Colors") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Array(appState.recentColors.prefix(10))) { color in
                            Button {
                                appState.selectRecentColor(color)
                            } label: {
                                SwatchCircle(hex: color.hex, size: 24)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button("Copy as \(appState.settings.preferredFormat.shortLabel)") {
                                    appState.copy(colorHex: color.hex, format: appState.settings.preferredFormat)
                                }
                                Button("Add to Palette") {
                                    if var palette = appState.activePalette {
                                        if !palette.colorHexValues.contains(color.hex) {
                                            palette.colorHexValues.insert(color.hex, at: 0)
                                        }
                                    }
                                }
                                Button("Remove from History", role: .destructive) {
                                    appState.removeRecentColor(color)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
