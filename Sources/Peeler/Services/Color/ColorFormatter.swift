import AppKit
import Foundation

enum ColorFormatter {
    static func string(for color: NSColor, format: CopyFormat) -> String {
        let components = ColorComponents(color)
        switch format {
        case .hex: return components.hex
        case .hexa: return components.hexa
        case .rgb: return components.rgbString
        case .rgba: return components.rgbaString
        case .hsl: return components.hslString
        case .hsla: return components.hslaString
        case .hsb: return components.hsbString
        case .swiftUIColor: return components.swiftUIColorString
        case .nsColor: return components.nsColorString
        case .uiColor: return components.uiColorString
        case .oklch: return components.oklchString
        }
    }

    static func exportString(for colors: [String], format: ExportFormat, paletteName: String?) -> String {
        switch format {
        case .cssVariables:
            cssVariables(colors: colors, paletteName: paletteName)
        case .tailwind:
            tailwindArray(colors: colors)
        case .json:
            jsonArray(colors: colors)
        case .hexList:
            colors.map { $0.uppercased() }.joined(separator: "\n")
        }
    }

    private static func cssVariables(colors: [String], paletteName: String?) -> String {
        let prefix = slugify(paletteName)
        let body = colors.enumerated().map { index, hex in
            "  --\(prefix)-\(index + 1): \(hex.uppercased());"
        }.joined(separator: "\n")

        return ":root {\n\(body)\n}"
    }

    private static func tailwindArray(colors: [String]) -> String {
        let tokens = colors.map { "'\($0.uppercased())'" }.joined(separator: ", ")
        return "[\(tokens)]"
    }

    private static func jsonArray(colors: [String]) -> String {
        let rows = colors.map { hex -> String in
            let nsColor = ColorParser.nsColor(from: hex) ?? .black
            let rgb = string(for: nsColor, format: .rgb)
            let hsl = string(for: nsColor, format: .hsl)
            return #"  { "hex": "\#(hex.uppercased())", "rgb": "\#(rgb)", "hsl": "\#(hsl)" }"#
        }.joined(separator: ",\n")

        return "[\n\(rows)\n]"
    }

    private static func slugify(_ value: String?) -> String {
        guard let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "color"
        }

        let allowed = value
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }

        return allowed.isEmpty ? "color" : allowed.joined(separator: "-")
    }
}
