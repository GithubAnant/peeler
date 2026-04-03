import AppKit
import SwiftUI

struct BrandBadgeView: View {
    var body: some View {
        Group {
            if let image = brandImage {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.accentColor.opacity(0.85),
                                    Color.accentColor.opacity(0.45),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    VStack(spacing: 3) {
                        Image(systemName: "app.badge")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Logo")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundStyle(.white.opacity(0.95))
                }
            }
        }
        .frame(width: 52, height: 52)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
        )
    }

    private var brandImage: NSImage? {
        guard let url = Bundle.module.url(forResource: "app-icon", withExtension: "png", subdirectory: "Brand") else {
            return nil
        }
        return NSImage(contentsOf: url)
    }
}
