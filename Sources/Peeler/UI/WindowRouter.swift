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
            size: NSSize(width: 460, height: 560),
            rootView: SettingsWindowView().environmentObject(appState)
        )
    }

    func showHistory() {
        showWindow(
            key: "history",
            title: "History",
            size: NSSize(width: 520, height: 580),
            rootView: HistoryWindowView().environmentObject(appState)
        )
    }

    func showSavedPalettes() {
        showWindow(
            key: "palettes",
            title: "Saved Palettes",
            size: NSSize(width: 560, height: 560),
            rootView: SavedPalettesView().environmentObject(appState)
        )
    }

    private func showWindow<V: View>(key: String, title: String, size: NSSize, rootView: V) {
        NSApp.activate(ignoringOtherApps: true)

        if let controller = controllers[key] {
            controller.showWindow(nil)
            controller.window?.orderFrontRegardless()
            controller.window?.makeKeyAndOrderFront(nil)
            controller.window?.makeMain()
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let controller = NSWindowController(window: makeWindow(title: title, size: size, rootView: rootView))
        controllers[key] = controller
        controller.showWindow(nil)
        controller.window?.center()
        controller.window?.orderFrontRegardless()
        controller.window?.makeKeyAndOrderFront(nil)
        controller.window?.makeMain()
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makeWindow<V: View>(title: String, size: NSSize, rootView: V) -> NSWindow {
        let hosting = NSHostingController(rootView: rootView)
        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
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
        return window
    }
}
