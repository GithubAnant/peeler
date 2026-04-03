import AppKit
import SwiftUI

@MainActor
final class WindowRouter {
    private let appState: AppState
    private var controllers: [String: NSWindowController] = [:]

    init(appState: AppState) {
        self.appState = appState
    }

    func showSettings() {
        showWindow(
            key: "settings",
            title: "Peeler Settings",
            size: NSSize(width: 980, height: 700),
            rootView: SettingsWindowView().environmentObject(appState)
        )
    }

    func showHistory() {
        showWindow(
            key: "history",
            title: "History",
            size: NSSize(width: 880, height: 640),
            rootView: HistoryWindowView().environmentObject(appState)
        )
    }

    func showSavedPalettes() {
        showWindow(
            key: "palettes",
            title: "Saved Palettes",
            size: NSSize(width: 920, height: 680),
            rootView: SavedPalettesView().environmentObject(appState)
        )
    }

    private func showWindow<V: View>(key: String, title: String, size: NSSize, rootView: V) {
        NSApp.activate(ignoringOtherApps: true)

        if let existing = controllers[key] {
            existing.close()
            controllers.removeValue(forKey: key)
        }

        let controller = NSWindowController(window: makeWindow(title: title, size: size, rootView: rootView))
        controllers[key] = controller
        applyWindowMetrics(controller.window, size: size)
        controller.showWindow(nil)
        controller.window?.center()
        controller.window?.orderFrontRegardless()
        controller.window?.makeKeyAndOrderFront(nil)
        controller.window?.makeMain()
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makeWindow<V: View>(title: String, size: NSSize, rootView: V) -> NSWindow {
        let hosting = NSHostingController(rootView: rootView)
        hosting.preferredContentSize = size

        let contentRect = NSRect(origin: .zero, size: size)
        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = title
        window.isReleasedWhenClosed = false
        window.contentViewController = hosting
        window.titlebarAppearsTransparent = true
        window.toolbarStyle = .unifiedCompact
        window.level = .normal
        window.hidesOnDeactivate = false
        window.isExcludedFromWindowsMenu = false
        window.isMovableByWindowBackground = true
        window.collectionBehavior = [.moveToActiveSpace, .fullScreenAuxiliary]
        window.setFrame(window.frameRect(forContentRect: contentRect), display: false)
        return window
    }

    private func applyWindowMetrics(_ window: NSWindow?, size: NSSize) {
        guard let window else { return }
        let contentRect = NSRect(origin: .zero, size: size)
        let frame = window.frameRect(forContentRect: contentRect)
        window.contentMinSize = size
        window.minSize = frame.size
        window.setContentSize(size)
        window.setFrame(frame, display: true)
    }
}
