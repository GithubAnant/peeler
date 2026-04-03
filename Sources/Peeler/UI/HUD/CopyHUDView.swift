import SwiftUI

struct CopyHUDView: View {
    let payload: HUDPayload

    var body: some View {
        HStack(spacing: 12) {
            SwatchCircle(hex: payload.colorHex, size: 16)
            VStack(alignment: .leading, spacing: 2) {
                Text(payload.format.shortLabel)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.secondary)
                Text(payload.copiedValue)
                    .font(.system(size: 12, design: .monospaced))
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        }
        .padding(.horizontal, 14)
        .frame(width: 240, height: 44)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}
