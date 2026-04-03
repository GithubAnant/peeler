import SwiftUI

struct PaletteContentView: View {
    @EnvironmentObject private var appState: AppState

    let palette: PaletteRecord
    let columns: [GridItem]
    @Binding var paletteName: String
    @Binding var exportSheetVisible: Bool

    var body: some View {
        VStack(spacing: 12) {
            PaletteGridSection(palette: palette, columns: columns)
            PaletteActionsSection(
                palette: palette,
                paletteName: $paletteName,
                exportSheetVisible: $exportSheetVisible
            )
        }
    }
}

struct PaletteGridSection: View {
    @EnvironmentObject private var appState: AppState

    let palette: PaletteRecord
    let columns: [GridItem]

    var body: some View {
        GroupCard {
            ThumbnailPreview(data: palette.thumbnailData)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(palette.colorHexValues, id: \.self) { hex in
                    Button {
                        appState.copy(colorHex: hex, format: appState.settings.preferredFormat)
                    } label: {
                        PaletteSwatchTile(hex: hex)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        ForEach([CopyFormat.hex, .rgb, .hsl], id: \.self) { format in
                            Button("Copy as \(format.shortLabel)") {
                                appState.copy(colorHex: hex, format: format)
                            }
                        }
                        Button("Remove from Palette", role: .destructive) {
                            appState.removeColorFromActivePalette(hex)
                        }
                    }
                }
            }
        }
    }
}

struct PaletteActionsSection: View {
    @EnvironmentObject private var appState: AppState

    let palette: PaletteRecord
    @Binding var paletteName: String
    @Binding var exportSheetVisible: Bool

    var body: some View {
        GroupCard("Actions") {
            HStack {
                Button("Copy All") {
                    let csv = palette.colorHexValues.joined(separator: ", ")
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(csv, forType: .string)
                }
                Button("Export") {
                    exportSheetVisible = true
                }
                Spacer()
            }

            HStack {
                TextField("Palette name", text: $paletteName)
                    .textFieldStyle(.roundedBorder)
                Button("Save Palette") {
                    let name = paletteName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !name.isEmpty else { return }
                    appState.saveActivePalette(named: name)
                    paletteName = ""
                }
            }
        }
    }
}

struct PaletteEmptyStateView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        GroupCard {
            VStack(spacing: 12) {
                Spacer(minLength: 18)
                Text("Use ⌘⇧X to capture a region")
                    .font(.headline)
                Text("Peeler will extract a clean palette, copy the dominant color, and open the panel here.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Capture Region") {
                    appState.triggerPaletteCapture?()
                }
                .buttonStyle(.borderedProminent)
                Spacer(minLength: 18)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
