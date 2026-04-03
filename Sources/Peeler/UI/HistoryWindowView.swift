import SwiftUI

struct HistoryWindowView: View {
    @EnvironmentObject private var appState: AppState

    private let colorColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    var body: some View {
        NativeWindowShell("History") {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    GroupCard("Recent Colors") {
                        if appState.recentColors.isEmpty {
                            Text("No picked colors yet. Use the eyedropper and they’ll show up here.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        } else {
                            LazyVGrid(columns: colorColumns, spacing: 12) {
                                ForEach(appState.recentColors) { color in
                                    Button {
                                        appState.selectRecentColor(color)
                                    } label: {
                                        VStack(spacing: 6) {
                                            SwatchCircle(hex: color.hex, size: 32)
                                            Text(color.hex)
                                                .font(.system(size: 10, design: .monospaced))
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    GroupCard("Recent Palettes") {
                        if appState.paletteHistory.isEmpty {
                            Text("No captured palettes yet. Capture a region with ⌘⇧X and it’ll appear here.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(appState.paletteHistory.prefix(20)) { palette in
                                GroupCard {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack(alignment: .firstTextBaseline) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(palette.displayName)
                                                    .font(.headline)
                                                Text(DateFormatter.paletteTitleFormatter.string(from: palette.createdAt))
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                            Spacer()
                                            Button("Open") {
                                                appState.loadPalette(palette)
                                            }
                                            .buttonStyle(.borderless)
                                        }

                                        CompactPaletteStrip(colors: palette.colorHexValues, maxColors: 6)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
