import AppKit

enum ColorParser {
    static func nsColor(from hex: String) -> NSColor? {
        let cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()

        var value: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&value) else { return nil }

        switch cleaned.count {
        case 6:
            return NSColor(
                srgbRed: CGFloat((value & 0xFF0000) >> 16) / 255,
                green: CGFloat((value & 0x00FF00) >> 8) / 255,
                blue: CGFloat(value & 0x0000FF) / 255,
                alpha: 1
            )
        case 8:
            return NSColor(
                srgbRed: CGFloat((value & 0xFF000000) >> 24) / 255,
                green: CGFloat((value & 0x00FF0000) >> 16) / 255,
                blue: CGFloat((value & 0x0000FF00) >> 8) / 255,
                alpha: CGFloat(value & 0x000000FF) / 255
            )
        default:
            return nil
        }
    }
}
