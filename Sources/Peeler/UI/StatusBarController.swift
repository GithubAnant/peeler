import AppKit
import SwiftUI

@MainActor
final class StatusBarController: NSObject {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let popover = NSPopover()
    private let onOpenPanel: () -> Void
    private let onTogglePanel: () -> Void
    private let onOpenHistory: () -> Void
    private let onOpenPalettes: () -> Void
    private let onOpenSettings: () -> Void

    var statusItemFrameInScreen: NSRect? {
        guard let button = statusItem.button, let window = button.window else { return nil }
        return window.convertToScreen(button.convert(button.bounds, to: nil))
    }

    init(
        appState: AppState,
        onOpenPanel: @escaping () -> Void,
        onTogglePanel: @escaping () -> Void,
        onOpenHistory: @escaping () -> Void,
        onOpenPalettes: @escaping () -> Void,
        onOpenSettings: @escaping () -> Void
    ) {
        self.onOpenPanel = onOpenPanel
        self.onTogglePanel = onTogglePanel
        self.onOpenHistory = onOpenHistory
        self.onOpenPalettes = onOpenPalettes
        self.onOpenSettings = onOpenSettings
        super.init()
        configureStatusItem()
        configurePopover(appState: appState)
    }

    func togglePanel() {
        if popover.isShown {
            closePanel()
        } else {
            showPanel()
        }
    }

    func showPanel() {
        guard let button = statusItem.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        popover.contentViewController?.view.window?.makeFirstResponder(nil)
    }

    func closePanel() {
        popover.performClose(nil)
    }

    @objc private func handleStatusItemPress(_ sender: Any?) {
        guard let event = NSApp.currentEvent else {
            onTogglePanel()
            return
        }

        switch event.type {
        case .rightMouseUp:
            closePanel()
            showContextMenu(with: event)
        default:
            onTogglePanel()
        }
    }

    private func configureStatusItem() {
        guard let button = statusItem.button else { return }
        let image = NSImage(systemSymbolName: "eyedropper", accessibilityDescription: "Peeler")
        image?.isTemplate = true
        button.image = image
        button.action = #selector(handleStatusItemPress(_:))
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    private func configurePopover(appState: AppState) {
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = NSSize(width: 320, height: 468)
        popover.contentViewController = NSHostingController(
            rootView: PanelRootView().environmentObject(appState)
        )
    }

    private func makeMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(withTitle: "History", action: #selector(openHistory), keyEquivalent: "")
        menu.addItem(withTitle: "Palettes", action: #selector(openPalettes), keyEquivalent: "")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Settings", action: #selector(openSettings), keyEquivalent: "")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit Peeler", action: #selector(quit), keyEquivalent: "q")
        menu.items.forEach { $0.target = self }
        return menu
    }

    private func showContextMenu(with event: NSEvent) {
        guard let button = statusItem.button else { return }
        let menu = makeMenu()
        NSMenu.popUpContextMenu(menu, with: event, for: button)
    }

    @objc private func openHistory() {
        closePanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [onOpenHistory] in
            onOpenHistory()
        }
    }

    @objc private func openPalettes() {
        closePanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [onOpenPalettes] in
            onOpenPalettes()
        }
    }

    @objc private func openSettings() {
        closePanel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [onOpenSettings] in
            onOpenSettings()
        }
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
