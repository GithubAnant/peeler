import SwiftUI

struct PaletteTabView: View {
    @EnvironmentObject private var appState: AppState
    @State private var exportSheetVisible = false
    @State private var paletteName = ""
    @State private var exportFormat: ExportFormat = .cssVariables

    var body: some View {
        if let palette = appState.activePalette {
            PaletteContentView(
                palette: palette,
                paletteName: $paletteName,
                exportSheetVisible: $exportSheetVisible
            )
            .sheet(isPresented: $exportSheetVisible) {
                ExportSheetView(
                    exportFormat: $exportFormat,
                    content: appState.exportString(for: exportFormat, palette: palette)
                )
            }
        } else {
            PaletteEmptyStateView()
        }
    }
}
