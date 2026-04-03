import SwiftUI

struct HistoryWindowView: View {
    @EnvironmentObject private var appState: AppState

    private let colorColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)

    var body: some View {
        NativeWindowShell("History") {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    GroupCard("Recent Colors") {
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

                    GroupCard("Recent Palettes") {
                        ForEach(appState.paletteHistory.prefix(20)) { palette in
                            Button {
                                appState.loadPalette(palette)
                            } label: {
                                HStack(spacing: 12) {
                                    ThumbnailPreview(data: palette.thumbnailData)
                                        .frame(width: 88)
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(palette.displayName)
                                            .font(.headline)
                                        Text(DateFormatter.paletteTitleFormatter.string(from: palette.createdAt))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        HStack(spacing: 6) {
                                            ForEach(palette.colorHexValues.prefix(6), id: \.self) { hex in
                                                SwatchCircle(hex: hex, size: 16)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            Divider()
                        }
                    }
                }
            }
        }
    }
}
