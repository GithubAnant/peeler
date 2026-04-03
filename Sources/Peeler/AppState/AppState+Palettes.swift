import AppKit

extension AppState {
    func handlePaletteCapture(image: NSImage, colors: [String]) {
        guard !colors.isEmpty else { return }

        let record = PaletteRecord(
            name: nil,
            createdAt: Date(),
            updatedAt: Date(),
            isSaved: false,
            thumbnailData: image.thumbnailJPEGData(maxDimension: 200),
            colorHexValues: colors
        )

        activePalette = record
        paletteHistory.insert(record, at: 0)
        paletteHistory = Array(paletteHistory.prefix(20))
        persistence.savePalettes(paletteHistory)
        copy(colorHex: colors[0], format: settings.preferredFormat)
        setSelectedTab(.palette)
    }

    func saveActivePalette(named name: String) {
        guard var activePalette else { return }

        activePalette.name = name
        activePalette.isSaved = true
        activePalette.updatedAt = Date()
        self.activePalette = activePalette

        if let index = paletteHistory.firstIndex(where: { $0.id == activePalette.id }) {
            paletteHistory[index] = activePalette
        } else {
            paletteHistory.insert(activePalette, at: 0)
        }

        persistence.savePalettes(paletteHistory)
    }

    func loadPalette(_ palette: PaletteRecord) {
        activePalette = palette
        setSelectedTab(.palette)
    }

    func clearActivePaletteSelection() {
        activePalette = nil
    }

    func renamePalette(_ palette: PaletteRecord, name: String) {
        guard let index = paletteHistory.firstIndex(where: { $0.id == palette.id }) else { return }
        paletteHistory[index].name = name
        paletteHistory[index].isSaved = true
        paletteHistory[index].updatedAt = Date()
        if activePalette?.id == palette.id {
            activePalette = paletteHistory[index]
        }
        persistence.savePalettes(paletteHistory)
    }

    func deletePalette(_ palette: PaletteRecord) {
        paletteHistory.removeAll(where: { $0.id == palette.id })
        if activePalette?.id == palette.id {
            activePalette = paletteHistory.first
        }
        persistence.savePalettes(paletteHistory)
    }

    func removeColorFromActivePalette(_ hex: String) {
        guard var activePalette else { return }
        activePalette.colorHexValues.removeAll(where: { $0.caseInsensitiveCompare(hex) == .orderedSame })
        activePalette.updatedAt = Date()
        self.activePalette = activePalette
        if let index = paletteHistory.firstIndex(where: { $0.id == activePalette.id }) {
            paletteHistory[index] = activePalette
        }
        persistence.savePalettes(paletteHistory)
    }

    func exportString(for format: ExportFormat, palette: PaletteRecord) -> String {
        ColorFormatter.exportString(for: palette.colorHexValues, format: format, paletteName: palette.name)
    }
}
