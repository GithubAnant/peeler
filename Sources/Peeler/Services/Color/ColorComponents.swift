import AppKit
import Foundation

struct ColorComponents {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double

    init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(_ color: NSColor) {
        let converted = color.usingColorSpace(.extendedSRGB) ?? color.usingColorSpace(.sRGB) ?? color
        self.red = converted.redComponent.double
        self.green = converted.greenComponent.double
        self.blue = converted.blueComponent.double
        self.alpha = converted.alphaComponent.double
    }

    var hex: String {
        String(
            format: "#%02X%02X%02X",
            Int(round(red * 255)),
            Int(round(green * 255)),
            Int(round(blue * 255))
        )
    }

    var hexa: String {
        String(
            format: "#%02X%02X%02X%02X",
            Int(round(red * 255)),
            Int(round(green * 255)),
            Int(round(blue * 255)),
            Int(round(alpha * 255))
        )
    }

    var rgbString: String {
        "rgb(\(rgbInt(red)), \(rgbInt(green)), \(rgbInt(blue)))"
    }

    var rgbaString: String {
        "rgba(\(rgbInt(red)), \(rgbInt(green)), \(rgbInt(blue)), \(alpha.formatted(.number.precision(.fractionLength(2)))))"
    }

    var hslString: String {
        let (h, s, l) = hsl
        return "hsl(\(Int(round(h))), \(Int(round(s * 100)))%, \(Int(round(l * 100)))%)"
    }

    var hslaString: String {
        let (h, s, l) = hsl
        return "hsla(\(Int(round(h))), \(Int(round(s * 100)))%, \(Int(round(l * 100)))%, \(alpha.formatted(.number.precision(.fractionLength(2)))))"
    }

    var hsbString: String {
        let (h, s, b) = hsb
        return "hsb(\(Int(round(h))), \(Int(round(s * 100)))%, \(Int(round(b * 100)))%)"
    }

    var swiftUIColorString: String {
        "Color(red: \(fraction(red)), green: \(fraction(green)), blue: \(fraction(blue)))"
    }

    var nsColorString: String {
        "NSColor(red: \(fraction(red)), green: \(fraction(green)), blue: \(fraction(blue)), alpha: \(fraction(alpha)))"
    }

    var uiColorString: String {
        "UIColor(red: \(fraction(red)), green: \(fraction(green)), blue: \(fraction(blue)), alpha: \(fraction(alpha)))"
    }

    var oklchString: String {
        let value = OKLCHConverter.convert(red: red, green: green, blue: blue)
        return "oklch(\(Int(round(value.l * 100)))% \(value.c.formatted(.number.precision(.fractionLength(3)))) \(Int(round(value.h))))"
    }

    private var hsl: (Double, Double, Double) {
        let maxValue = max(red, green, blue)
        let minValue = min(red, green, blue)
        let delta = maxValue - minValue
        let lightness = (maxValue + minValue) / 2

        guard delta > 0 else {
            return (0, 0, lightness)
        }

        let saturation = delta / (1 - abs(2 * lightness - 1))
        let hue: Double

        switch maxValue {
        case red:
            hue = 60 * (((green - blue) / delta).truncatingRemainder(dividingBy: 6))
        case green:
            hue = 60 * (((blue - red) / delta) + 2)
        default:
            hue = 60 * (((red - green) / delta) + 4)
        }

        return (hue < 0 ? hue + 360 : hue, saturation, lightness)
    }

    private var hsb: (Double, Double, Double) {
        let maxValue = max(red, green, blue)
        let minValue = min(red, green, blue)
        let delta = maxValue - minValue
        let brightness = maxValue

        guard delta > 0 else {
            return (0, 0, brightness)
        }

        let saturation = maxValue == 0 ? 0 : delta / maxValue
        let hue: Double

        switch maxValue {
        case red:
            hue = 60 * (((green - blue) / delta).truncatingRemainder(dividingBy: 6))
        case green:
            hue = 60 * (((blue - red) / delta) + 2)
        default:
            hue = 60 * (((red - green) / delta) + 4)
        }

        return (hue < 0 ? hue + 360 : hue, saturation, brightness)
    }

    private func rgbInt(_ value: Double) -> Int {
        Int(round(value * 255))
    }

    private func fraction(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(2)))
    }
}

private extension CGFloat {
    var double: Double { Double(self) }
}
