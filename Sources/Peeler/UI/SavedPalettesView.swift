import SwiftUI

struct SavedPalettesView: View {
    @EnvironmentObject private var appState: AppState
    @State private var exportFormat: ExportFormat = .cssVariables
    @State private var selectedPalette: PaletteRecord?

    var body: some View {
        NativeWindowShell("Saved Palettes") {
            ScrollView {
                VStack(spacing: 16) {
                    if appState.savedPalettes.isEmpty {
                        GroupCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("No saved palettes yet")
                                    .font(.headline)
                                Text("Generate a palette from a screen region, give it a name, and it will live here.")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        ForEach(appState.savedPalettes) { palette in
                            GroupCard {
                                HStack(alignment: .top, spacing: 14) {
                                    ThumbnailPreview(data: palette.thumbnailData)
                                        .frame(width: 96)
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(palette.displayName)
                                            .font(.headline)
                                        Text("Saved \(DateFormatter.paletteTitleFormatter.string(from: palette.updatedAt))")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        HStack(spacing: 6) {
                                            ForEach(palette.colorHexValues, id: \.self) { hex in
                                                SwatchCircle(hex: hex, size: 18)
                                            }
                                        }
                                        HStack {
                                            Button("Open in Panel") {
                                                appState.loadPalette(palette)
                                            }
                                            Button("Export") {
                                                selectedPalette = palette
                                            }
                                            Button("Delete", role: .destructive) {
                                                appState.deletePalette(palette)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedPalette) { palette in
            ExportSheetView(
                exportFormat: $exportFormat,
                content: appState.exportString(for: exportFormat, palette: palette)
            )
        }
    }
}
