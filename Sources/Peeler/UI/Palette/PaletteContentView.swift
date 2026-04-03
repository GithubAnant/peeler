import SwiftUI

struct PaletteContentView: View {
    let palette: PaletteRecord
    @Binding var paletteName: String
    @Binding var exportSheetVisible: Bool

    var body: some View {
        VStack(spacing: 12) {
            PaletteGridSection(palette: palette)
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

    var body: some View {
        GroupCard {
            HStack(alignment: .center) {
                Text("Selected Region")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Clear Selection") {
                    appState.clearActivePaletteSelection()
                }
                .buttonStyle(.link)
            }

            ThumbnailPreview(data: palette.thumbnailData)

            CompactPaletteStrip(colors: palette.colorHexValues)

            Text("Click any color to copy it in \(appState.settings.preferredFormat.shortLabel).")
                .font(.caption)
                .foregroundStyle(.secondary)
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
                Button("Capture Again") {
                    appState.triggerPaletteCapture?()
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
