import AppKit
import SwiftUI

@MainActor
final class StatusBarController: NSObject {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let popover = NSPopover()
    private let appState: AppState
    private let onOpenPanel: () -> Void
    private let onTogglePanel: () -> Void

    var statusItemFrameInScreen: NSRect? {
        guard let button = statusItem.button, let window = button.window else { return nil }
        return window.convertToScreen(button.convert(button.bounds, to: nil))
    }

    init(appState: AppState, onOpenPanel: @escaping () -> Void, onTogglePanel: @escaping () -> Void) {
        self.appState = appState
        self.onOpenPanel = onOpenPanel
        self.onTogglePanel = onTogglePanel
        super.init()
        configureStatusItem()
        configurePopover()
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
            showContextMenu()
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

    private func configurePopover() {
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

    private func showContextMenu() {
        guard let button = statusItem.button else { return }
        let menu = makeMenu()
        menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.maxY + 6), in: button)
    }

    @objc private func openHistory() {
        closePanel()
        appState.openHistoryWindow?()
    }

    @objc private func openPalettes() {
        closePanel()
        appState.openSavedPalettesWindow?()
    }

    @objc private func openSettings() {
        closePanel()
        appState.openSettingsWindow?()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
