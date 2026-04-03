import AppKit
import SwiftUI

@MainActor
final class HUDPanelController {
    private var panel: NSPanel?
    private var hideTask: Task<Void, Never>?

    func show(payload: HUDPayload, anchorFrame: NSRect?) {
        hideTask?.cancel()

        let controller = NSHostingController(rootView: CopyHUDView(payload: payload))
        let panel = panel ?? makePanel()
        panel.contentViewController = controller
        panel.setContentSize(NSSize(width: 240, height: 44))

        let screenFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
        let frame = anchorFrame ?? NSRect(x: screenFrame.maxX - 280, y: screenFrame.maxY - 12, width: 32, height: 24)
        let origin = NSPoint(x: frame.midX - 120, y: frame.minY - 54)
        panel.setFrameOrigin(origin)
        panel.alphaValue = 0
        panel.orderFrontRegardless()

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            panel.animator().alphaValue = 1
        }

        hideTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(1.2))
            guard let self, let panel = self.panel else { return }
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                panel.animator().alphaValue = 0
            }, completionHandler: {
                panel.orderOut(nil)
            })
        }

        self.panel = panel
    }

    private func makePanel() -> NSPanel {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 240, height: 44),
            styleMask: [.nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .statusBar
        panel.hasShadow = true
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        return panel
    }
}
