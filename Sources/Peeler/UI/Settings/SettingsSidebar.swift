import SwiftUI

enum SettingsPane: String, CaseIterable, Identifiable {
    case general
    case hotkeys
    case appearance
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .general: "General"
        case .hotkeys: "Hotkeys"
        case .appearance: "Appearance"
        case .about: "About"
        }
    }

    var icon: String {
        switch self {
        case .general: "gearshape"
        case .hotkeys: "command"
        case .appearance: "circle.lefthalf.filled"
        case .about: "info.circle"
        }
    }
}

struct SettingsSidebar: View {
    @Binding var selection: SettingsPane

    var body: some View {
        List(SettingsPane.allCases, selection: $selection) { pane in
            Label(pane.title, systemImage: pane.icon)
                .tag(pane)
                .font(.system(size: 15, weight: .medium))
                .padding(.vertical, 4)
        }
        .listStyle(.sidebar)
        .navigationSplitViewColumnWidth(min: 220, ideal: 240)
    }
}
