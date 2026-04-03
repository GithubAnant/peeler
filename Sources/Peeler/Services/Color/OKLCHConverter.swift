import Foundation

enum OKLCHConverter {
    struct Result {
        var l: Double
        var c: Double
        var h: Double
    }

    static func convert(red: Double, green: Double, blue: Double) -> Result {
        let linear = (r: linearize(red), g: linearize(green), b: linearize(blue))

        let l = 0.4122214708 * linear.r + 0.5363325363 * linear.g + 0.0514459929 * linear.b
        let m = 0.2119034982 * linear.r + 0.6806995451 * linear.g + 0.1073969566 * linear.b
        let s = 0.0883024619 * linear.r + 0.2817188376 * linear.g + 0.6299787005 * linear.b

        let lRoot = cbrt(l)
        let mRoot = cbrt(m)
        let sRoot = cbrt(s)

        let okl = 0.2104542553 * lRoot + 0.793617785 * mRoot - 0.0040720468 * sRoot
        let oka = 1.9779984951 * lRoot - 2.428592205 * mRoot + 0.4505937099 * sRoot
        let okb = 0.0259040371 * lRoot + 0.7827717662 * mRoot - 0.808675766 * sRoot

        let chroma = sqrt(oka * oka + okb * okb)
        let hue = atan2(okb, oka) * 180 / .pi

        return Result(l: okl, c: chroma, h: hue >= 0 ? hue : hue + 360)
    }

    private static func linearize(_ value: Double) -> Double {
        value <= 0.04045 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
    }
}
