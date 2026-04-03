import AppKit
import Carbon
import Foundation

enum PanelTab: String, Codable, CaseIterable, Identifiable {
    case eyedropper
    case palette

    var id: String { rawValue }

    var title: String {
        switch self {
        case .eyedropper: "Eyedropper"
        case .palette: "Palette"
        }
    }
}

enum CopyFormat: String, Codable, CaseIterable, Identifiable {
    case hex
    case hexa
    case rgb
    case rgba
    case hsl
    case hsla
    case hsb
    case swiftUIColor = "swiftui"
    case nsColor
    case uiColor
    case oklch

    var id: String { rawValue }

    var shortLabel: String {
        switch self {
        case .hex: "HEX"
        case .hexa: "HEXA"
        case .rgb: "RGB"
        case .rgba: "RGBA"
        case .hsl: "HSL"
        case .hsla: "HSLA"
        case .hsb: "HSB"
        case .swiftUIColor: "SwiftUI"
        case .nsColor: "NSColor"
        case .uiColor: "UIColor"
        case .oklch: "OKLCH"
        }
    }

    var menuTitle: String {
        switch self {
        case .swiftUIColor: "SwiftUI Color"
        default: shortLabel
        }
    }
}

enum AppTheme: String, Codable, CaseIterable, Identifiable {
    case system
    case dark
    case light

    var id: String { rawValue }

    var title: String { rawValue.capitalized }
}

enum PanelPlacement: String, Codable, CaseIterable, Identifiable {
    case auto
    case topRight
    case topLeft

    var id: String { rawValue }

    var title: String {
        switch self {
        case .auto: "Auto"
        case .topRight: "Top-right"
        case .topLeft: "Top-left"
        }
    }
}

enum ExportFormat: String, CaseIterable, Identifiable {
    case cssVariables
    case tailwind
    case json
    case hexList

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cssVariables: "CSS Variables"
        case .tailwind: "Tailwind Array"
        case .json: "JSON"
        case .hexList: "Plain Hex List"
        }
    }
}

struct HotKeyCombination: Codable, Hashable {
    var keyCode: UInt32
    var carbonModifiers: UInt32

    init(keyCode: UInt32, carbonModifiers: UInt32) {
        self.keyCode = keyCode
        self.carbonModifiers = carbonModifiers
    }

    static let eyedropperDefault = HotKeyCombination(
        keyCode: UInt32(kVK_ANSI_C),
        carbonModifiers: UInt32(cmdKey | shiftKey)
    )

    static let paletteDefault = HotKeyCombination(
        keyCode: UInt32(kVK_ANSI_X),
        carbonModifiers: UInt32(cmdKey | shiftKey)
    )

    var displayString: String {
        var parts: [String] = []
        if carbonModifiers & UInt32(controlKey) != 0 { parts.append("⌃") }
        if carbonModifiers & UInt32(optionKey) != 0 { parts.append("⌥") }
        if carbonModifiers & UInt32(shiftKey) != 0 { parts.append("⇧") }
        if carbonModifiers & UInt32(cmdKey) != 0 { parts.append("⌘") }
        parts.append(keyCode.displayKey)
        return parts.joined()
    }

    var isValid: Bool {
        hasAnyModifier && keyCode.isRecordableKey
    }

    var hasAnyModifier: Bool {
        carbonModifiers & UInt32(cmdKey | optionKey | controlKey | shiftKey) != 0
    }

    init?(event: NSEvent) {
        let keyCode = UInt32(event.keyCode)
        let modifiers = event.modifierFlags.carbonHotKeyModifiers
        let combination = HotKeyCombination(keyCode: keyCode, carbonModifiers: modifiers)

        guard combination.isValid else {
            return nil
        }

        self = combination
    }
}

struct AppSettings: Codable {
    var preferredFormat: CopyFormat = .hex
    var paletteColorCount: Int = 6
    var launchAtLogin: Bool = false
    var playCopySound: Bool = true
    var theme: AppTheme = .system
    var panelPosition: PanelPlacement = .auto
    var eyedropperHotkey: HotKeyCombination = .eyedropperDefault
    var paletteHotkey: HotKeyCombination = .paletteDefault
    var lastActiveTab: PanelTab = .eyedropper

    enum CodingKeys: String, CodingKey {
        case preferredFormat
        case paletteColorCount
        case launchAtLogin
        case playCopySound
        case theme
        case panelPosition
        case eyedropperHotkey
        case paletteHotkey
        case lastActiveTab
    }

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        preferredFormat = try container.decodeIfPresent(CopyFormat.self, forKey: .preferredFormat) ?? .hex
        paletteColorCount = try container.decodeIfPresent(Int.self, forKey: .paletteColorCount) ?? 6
        launchAtLogin = try container.decodeIfPresent(Bool.self, forKey: .launchAtLogin) ?? false
        playCopySound = try container.decodeIfPresent(Bool.self, forKey: .playCopySound) ?? true
        theme = try container.decodeIfPresent(AppTheme.self, forKey: .theme) ?? .system
        panelPosition = try container.decodeIfPresent(PanelPlacement.self, forKey: .panelPosition) ?? .auto
        eyedropperHotkey = try container.decodeIfPresent(HotKeyCombination.self, forKey: .eyedropperHotkey) ?? .eyedropperDefault
        paletteHotkey = try container.decodeIfPresent(HotKeyCombination.self, forKey: .paletteHotkey) ?? .paletteDefault
        lastActiveTab = try container.decodeIfPresent(PanelTab.self, forKey: .lastActiveTab) ?? .eyedropper
    }

    mutating func normalize() {
        paletteColorCount = min(max(paletteColorCount, 4), 10)
    }
}

struct ColorToken: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var hex: String
    var createdAt: Date = Date()

    var colorName: String { hex.uppercased() }

    var nsColor: NSColor {
        ColorParser.nsColor(from: hex) ?? NSColor(calibratedWhite: 0.55, alpha: 1)
    }
}

struct PaletteRecord: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var isSaved: Bool = false
    var thumbnailData: Data?
    var colorHexValues: [String]

    var displayName: String {
        if let name, !name.isEmpty {
            return name
        }
        return DateFormatter.paletteTitleFormatter.string(from: createdAt)
    }
}

struct HUDPayload: Equatable {
    var colorHex: String
    var format: CopyFormat
    var copiedValue: String
}

struct PersistedPaletteStore: Codable {
    var palettes: [PaletteRecord] = []
}

extension DateFormatter {
    static let paletteTitleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension UInt32 {
    var displayKey: String {
        switch self {
        case UInt32(kVK_ANSI_A): "A"
        case UInt32(kVK_ANSI_B): "B"
        case UInt32(kVK_ANSI_C): "C"
        case UInt32(kVK_ANSI_D): "D"
        case UInt32(kVK_ANSI_E): "E"
        case UInt32(kVK_ANSI_F): "F"
        case UInt32(kVK_ANSI_G): "G"
        case UInt32(kVK_ANSI_H): "H"
        case UInt32(kVK_ANSI_I): "I"
        case UInt32(kVK_ANSI_J): "J"
        case UInt32(kVK_ANSI_K): "K"
        case UInt32(kVK_ANSI_L): "L"
        case UInt32(kVK_ANSI_M): "M"
        case UInt32(kVK_ANSI_N): "N"
        case UInt32(kVK_ANSI_O): "O"
        case UInt32(kVK_ANSI_P): "P"
        case UInt32(kVK_ANSI_Q): "Q"
        case UInt32(kVK_ANSI_R): "R"
        case UInt32(kVK_ANSI_S): "S"
        case UInt32(kVK_ANSI_T): "T"
        case UInt32(kVK_ANSI_U): "U"
        case UInt32(kVK_ANSI_V): "V"
        case UInt32(kVK_ANSI_W): "W"
        case UInt32(kVK_ANSI_X): "X"
        case UInt32(kVK_ANSI_Y): "Y"
        case UInt32(kVK_ANSI_Z): "Z"
        case UInt32(kVK_ANSI_0): "0"
        case UInt32(kVK_ANSI_1): "1"
        case UInt32(kVK_ANSI_2): "2"
        case UInt32(kVK_ANSI_3): "3"
        case UInt32(kVK_ANSI_4): "4"
        case UInt32(kVK_ANSI_5): "5"
        case UInt32(kVK_ANSI_6): "6"
        case UInt32(kVK_ANSI_7): "7"
        case UInt32(kVK_ANSI_8): "8"
        case UInt32(kVK_ANSI_9): "9"
        case UInt32(kVK_Space): "Space"
        case UInt32(kVK_ANSI_Minus): "-"
        case UInt32(kVK_ANSI_Equal): "="
        case UInt32(kVK_ANSI_LeftBracket): "["
        case UInt32(kVK_ANSI_RightBracket): "]"
        case UInt32(kVK_ANSI_Semicolon): ";"
        case UInt32(kVK_ANSI_Quote): "'"
        case UInt32(kVK_ANSI_Comma): ","
        case UInt32(kVK_ANSI_Period): "."
        case UInt32(kVK_ANSI_Slash): "/"
        case UInt32(kVK_ANSI_Backslash): "\\"
        case UInt32(kVK_Escape): "Esc"
        case UInt32(kVK_Return): "↩"
        default: String(UnicodeScalar(Int(self)) ?? " ")
        }
    }

    var isRecordableKey: Bool {
        switch self {
        case UInt32(kVK_Shift),
            UInt32(kVK_RightShift),
            UInt32(kVK_Command),
            UInt32(kVK_RightCommand),
            UInt32(kVK_Option),
            UInt32(kVK_RightOption),
            UInt32(kVK_Control),
            UInt32(kVK_RightControl),
            UInt32(kVK_CapsLock),
            UInt32(kVK_Function):
            false
        default:
            true
        }
    }
}

extension NSEvent.ModifierFlags {
    var carbonHotKeyModifiers: UInt32 {
        var modifiers: UInt32 = 0
        if contains(.command) { modifiers |= UInt32(cmdKey) }
        if contains(.option) { modifiers |= UInt32(optionKey) }
        if contains(.control) { modifiers |= UInt32(controlKey) }
        if contains(.shift) { modifiers |= UInt32(shiftKey) }
        return modifiers
    }
}
