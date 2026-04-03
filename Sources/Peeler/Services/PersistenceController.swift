import Foundation

final class PersistenceController {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private enum Keys {
        static let settings = "peeler.settings"
        static let recentColors = "peeler.recentColors"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadSettings() -> AppSettings {
        guard
            let data = defaults.data(forKey: Keys.settings),
            let settings = try? decoder.decode(AppSettings.self, from: data)
        else {
            return AppSettings()
        }

        var normalized = settings
        normalized.normalize()
        return normalized
    }

    func saveSettings(_ settings: AppSettings) {
        var normalized = settings
        normalized.normalize()
        guard let data = try? encoder.encode(normalized) else { return }
        defaults.set(data, forKey: Keys.settings)
    }

    func loadRecentColors() -> [ColorToken] {
        guard
            let data = defaults.data(forKey: Keys.recentColors),
            let colors = try? decoder.decode([ColorToken].self, from: data)
        else {
            return []
        }
        return colors
    }

    func saveRecentColors(_ colors: [ColorToken]) {
        guard let data = try? encoder.encode(colors) else { return }
        defaults.set(data, forKey: Keys.recentColors)
    }

    func loadPalettes() -> [PaletteRecord] {
        let url = paletteStoreURL()
        guard
            let data = try? Data(contentsOf: url),
            let store = try? decoder.decode(PersistedPaletteStore.self, from: data)
        else {
            return []
        }
        return store.palettes
    }

    func savePalettes(_ palettes: [PaletteRecord]) {
        let store = PersistedPaletteStore(palettes: palettes)
        guard let data = try? encoder.encode(store) else { return }
        let url = paletteStoreURL()
        try? FileManager.default.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try? data.write(to: url, options: .atomic)
    }

    private func paletteStoreURL() -> URL {
        let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())

        return baseURL
            .appendingPathComponent("Peeler", isDirectory: true)
            .appendingPathComponent("palettes.json")
    }
}
