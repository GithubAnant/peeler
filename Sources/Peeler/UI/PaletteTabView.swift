import SwiftUI

struct PaletteTabView: View {
    @EnvironmentObject private var appState: AppState
    @State private var exportSheetVisible = false
    @State private var paletteName = ""
    @State private var exportFormat: ExportFormat = .cssVariables

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]

    var body: some View {
        if let palette = appState.activePalette {
            PaletteContentView(
                palette: palette,
                columns: columns,
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
