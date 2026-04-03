import AppKit
import CoreGraphics

@MainActor
struct PaletteExtractionService {
    func extractPalette(from image: NSImage, count: Int) async -> [String] {
        guard let cgImage = image.cgImageValue else { return [] }
        let pixels = cgImage.sampledPixels(limit: 2200)
        guard !pixels.isEmpty else { return [] }

        return await Task.detached(priority: .userInitiated) {
            let targetColors = max(4, min(10, count))
            var centroids = stride(from: 0, to: min(targetColors, pixels.count), by: 1).map {
                pixels[$0 * pixels.count / min(targetColors, pixels.count)]
            }

            for _ in 0..<10 {
                var buckets = Array(repeating: [SIMD3<Double>](), count: centroids.count)

                for pixel in pixels {
                    let index = centroids.enumerated().min(by: {
                        simd_distance_squared($0.element, pixel) < simd_distance_squared($1.element, pixel)
                    })?.offset ?? 0
                    buckets[index].append(pixel)
                }

                for index in centroids.indices {
                    guard !buckets[index].isEmpty else { continue }
                    let sum = buckets[index].reduce(SIMD3<Double>(repeating: 0), +)
                    centroids[index] = sum / Double(buckets[index].count)
                }
            }

            let unique = Dictionary(grouping: centroids) { centroid in
                let color = NSColor(
                    srgbRed: centroid.x.cgFloat,
                    green: centroid.y.cgFloat,
                    blue: centroid.z.cgFloat,
                    alpha: 1
                )
                return ColorComponents(color).hex
            }
            .keys
            .sorted()

            return Array(unique.prefix(targetColors))
        }.value
    }
}

private extension CGImage {
    var bitmapContext: CGContext? {
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
        return CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
    }

    func sampledPixels(limit: Int) -> [SIMD3<Double>] {
        guard let context = bitmapContext else { return [] }
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let data = context.data else { return [] }

        let bytes = data.bindMemory(to: UInt8.self, capacity: width * height * 4)
        let pixelStride = max(1, Int(sqrt(Double(width * height) / Double(limit))))

        var pixels: [SIMD3<Double>] = []
        pixels.reserveCapacity(limit)

        for y in Swift.stride(from: 0, to: height, by: pixelStride) {
            for x in Swift.stride(from: 0, to: width, by: pixelStride) {
                let offset = ((y * width) + x) * 4
                let alpha = Double(bytes[offset + 3]) / 255
                guard alpha > 0.2 else { continue }
                pixels.append(SIMD3<Double>(
                    Double(bytes[offset]) / 255,
                    Double(bytes[offset + 1]) / 255,
                    Double(bytes[offset + 2]) / 255
                ))
            }
        }

        return pixels
    }
}

private extension NSImage {
    var cgImageValue: CGImage? {
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}

private extension Double {
    var cgFloat: CGFloat { CGFloat(self) }
}

private func simd_distance_squared(_ lhs: SIMD3<Double>, _ rhs: SIMD3<Double>) -> Double {
    let delta = lhs - rhs
    return delta.x * delta.x + delta.y * delta.y + delta.z * delta.z
}
