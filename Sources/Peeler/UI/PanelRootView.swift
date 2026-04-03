import SwiftUI

struct PanelRootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 14) {
            Picker("Mode", selection: binding(for: appState.settings.lastActiveTab)) {
                ForEach(PanelTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)

            if let hotKeyConflictMessage = appState.hotKeyConflictMessage {
                Text(hotKeyConflictMessage)
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ScrollView(.vertical, showsIndicators: false) {
                switch appState.settings.lastActiveTab {
                case .eyedropper:
                    EyedropperTabView()
                case .palette:
                    PaletteTabView()
                }
            }
        }
        .padding(12)
        .frame(width: 320, height: 468, alignment: .top)
        .macPanelBackground()
    }

    private func binding(for tab: PanelTab) -> Binding<PanelTab> {
        Binding(
            get: { appState.settings.lastActiveTab },
            set: { appState.setSelectedTab($0) }
        )
    }
}
