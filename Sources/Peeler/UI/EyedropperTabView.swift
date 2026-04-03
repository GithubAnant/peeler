import SwiftUI

struct EyedropperTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 12) {
            GroupCard {
                HStack(alignment: .center, spacing: 12) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(nsColor: appState.currentColor?.nsColor ?? NSColor(calibratedWhite: 0.34, alpha: 1)))
                        .frame(width: 78, height: 78)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(Color.white.opacity(0.05), lineWidth: 0.75)
                        )

                    VStack(alignment: .leading, spacing: 6) {
                        Text(appState.settings.preferredFormat.shortLabel)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)

                        if appState.currentColor == nil {
                            Text("Pick a color to get started")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text(appState.currentColorValue)
                                .font(.system(size: 16, weight: .medium, design: .monospaced))
                                .textSelection(.enabled)
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Spacer(minLength: 0)
                }

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
