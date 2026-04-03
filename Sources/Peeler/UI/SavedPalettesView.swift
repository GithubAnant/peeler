import SwiftUI

struct SavedPalettesView: View {
    @EnvironmentObject private var appState: AppState
    @State private var exportFormat: ExportFormat = .cssVariables
    @State private var selectedPalette: PaletteRecord?

    var body: some View {
        NativeWindowShell("Saved Palettes") {
            if appState.savedPalettes.isEmpty {
                GroupCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("No saved palettes yet")
                            .font(.headline)
                        Text("Captured palettes appear in History first. Save one with a name from the Palette tab and it will show up here.")
                            .foregroundStyle(.secondary)
                        Text("Flow: capture region -> review palette -> enter name -> Save Palette")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 6)
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(appState.savedPalettes) { palette in
                            GroupCard {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(alignment: .firstTextBaseline) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(palette.displayName)
                                                .font(.headline)
                                            Text("Saved \(DateFormatter.paletteTitleFormatter.string(from: palette.updatedAt))")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Button("Open") {
                                            appState.loadPalette(palette)
                                        }
                                        Button("Export") {
                                            selectedPalette = palette
                                        }
                                        Button("Delete", role: .destructive) {
                                            appState.deletePalette(palette)
                                        }
                                    }

                                    CompactPaletteStrip(colors: palette.colorHexValues)
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
