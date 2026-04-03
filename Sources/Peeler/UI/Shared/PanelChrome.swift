import SwiftUI

struct MacPanelBackground: ViewModifier {
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: 18, style: .continuous)

        content
            .background(
                ZStack {
                    shape
                        .fill(.ultraThinMaterial)
                    shape
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.white.opacity(0.02),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.18), radius: 14, x: 0, y: 10)
            )
            .clipShape(shape)
            .overlay(
                shape.strokeBorder(Color.white.opacity(0.05), lineWidth: 0.75)
            )
    }
}

extension View {
    func macPanelBackground() -> some View {
        modifier(MacPanelBackground())
    }
}

struct GroupCard<Content: View>: View {
    let title: String?
    @ViewBuilder var content: Content

    init(_ title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 14, style: .continuous)

        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }

            content
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            shape
                .fill(Color.white.opacity(0.045))
        )
        .clipShape(shape)
        .overlay(
            shape
                .strokeBorder(Color.white.opacity(0.035), lineWidth: 0.75)
        )
    }
}

struct NativeWindowShell<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
            }

            content
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            LinearGradient(
                colors: [
                    Color(nsColor: .windowBackgroundColor),
                    Color(nsColor: .underPageBackgroundColor),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
