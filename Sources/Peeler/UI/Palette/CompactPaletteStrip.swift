import SwiftUI

struct CompactPaletteStrip: View {
    @EnvironmentObject private var appState: AppState

    let colors: [String]
    var height: CGFloat = 54
    var cornerRadius: CGFloat = 16
    var maxColors: Int? = nil

    private var displayedColors: [String] {
        if let maxColors {
            return Array(colors.prefix(maxColors))
        }
        return colors
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(displayedColors.enumerated()), id: \.offset) { index, hex in
                Button {
                    appState.copy(colorHex: hex, format: appState.settings.preferredFormat)
                } label: {
                    Rectangle()
                        .fill(Color(nsColor: ColorParser.nsColor(from: hex) ?? .gray))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(alignment: .trailing) {
                            if index < displayedColors.count - 1 {
                                Rectangle()
                                    .fill(Color.white.opacity(0.12))
                                    .frame(width: 0.75)
                            }
                        }
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .contextMenu {
                    ForEach([CopyFormat.hex, .rgb, .hsl], id: \.self) { format in
                        Button("Copy as \(format.shortLabel)") {
                            appState.copy(colorHex: hex, format: format)
                        }
                    }
                }
            }
        }
        .frame(height: height)
        .background(Color.white.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.75)
        )
    }
}
