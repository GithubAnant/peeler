import AppKit
import SwiftUI

struct SwatchCircle: View {
    let hex: String
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(Color(nsColor: ColorParser.nsColor(from: hex) ?? .gray))
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .strokeBorder(Color.white.opacity(0.12), lineWidth: 0.75)
            )
    }
}

struct PaletteSwatchTile: View {
    let hex: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(nsColor: ColorParser.nsColor(from: hex) ?? .gray))
                .frame(height: 76)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.75)
                )

            Text(hex.uppercased())
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.primary.opacity(0.92))
        }
    }
}

struct ThumbnailPreview: View {
    let data: Data?

    var body: some View {
        if let data, let image = NSImage(data: data) {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.75)
                )
        } else {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .frame(height: 72)
                .overlay(
                    VStack(spacing: 6) {
                        Image(systemName: "photo")
                        Text("Region Preview")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                )
        }
    }
}
