import AppKit
import Carbon
import SwiftUI

struct HotKeyRecorderField: NSViewRepresentable {
    let title: String
    let combination: HotKeyCombination
    let onCommit: (HotKeyCombination) -> Void

    func makeNSView(context: Context) -> RecorderView {
        let view = RecorderView(frame: .zero)
        view.title = title
        view.onCommit = onCommit
        view.update(combination: combination)
        return view
    }

    func updateNSView(_ nsView: RecorderView, context: Context) {
        nsView.title = title
        nsView.onCommit = onCommit
        nsView.update(combination: combination)
    }
}

final class RecorderView: NSView {
    private let label = NSTextField(labelWithString: "")
    private let helper = NSTextField(labelWithString: "")
    private var trackingArea: NSTrackingArea?

    var title: String = ""
    var onCommit: ((HotKeyCombination) -> Void)?

    private var currentCombination: HotKeyCombination = .eyedropperDefault
    private var isRecording = false {
        didSet { updateAppearance() }
    }
    private var isHovered = false {
        didSet { updateAppearance() }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.cornerRadius = 12
        layer?.masksToBounds = true

        label.font = .monospacedSystemFont(ofSize: 13, weight: .semibold)
        helper.font = .systemFont(ofSize: 11, weight: .medium)
        helper.textColor = .secondaryLabelColor

        addSubview(label)
        addSubview(helper)

        label.translatesAutoresizingMaskIntoConstraints = false
        helper.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            helper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            helper.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            helper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            helper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])

        updateAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var acceptsFirstResponder: Bool { true }

    override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
        isRecording = true
    }

    override func resignFirstResponder() -> Bool {
        isRecording = false
        return true
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == UInt16(kVK_Escape) {
            isRecording = false
            window?.makeFirstResponder(nil)
            return
        }

        guard let combination = HotKeyCombination(event: event) else {
            NSSound.beep()
            return
        }

        currentCombination = combination
        onCommit?(combination)
        isRecording = false
        window?.makeFirstResponder(nil)
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        if let trackingArea {
            removeTrackingArea(trackingArea)
        }

        let area = NSTrackingArea(
            rect: bounds,
            options: [.activeInActiveApp, .mouseEnteredAndExited, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
        trackingArea = area
    }

    override func mouseEntered(with event: NSEvent) {
        isHovered = true
    }

    override func mouseExited(with event: NSEvent) {
        isHovered = false
    }

    func update(combination: HotKeyCombination) {
        currentCombination = combination
        updateAppearance()
    }

    private func updateAppearance() {
        let strokeColor: NSColor
        let fillColor: NSColor

        if isRecording {
            strokeColor = .controlAccentColor
            fillColor = NSColor.controlAccentColor.withAlphaComponent(0.16)
        } else if isHovered {
            strokeColor = NSColor.separatorColor.withAlphaComponent(0.9)
            fillColor = NSColor.quaternaryLabelColor.withAlphaComponent(0.12)
        } else {
            strokeColor = NSColor.separatorColor.withAlphaComponent(0.65)
            fillColor = NSColor.quaternaryLabelColor.withAlphaComponent(0.08)
        }

        layer?.backgroundColor = fillColor.cgColor
        layer?.borderColor = strokeColor.cgColor
        layer?.borderWidth = isRecording ? 1.2 : 0.8

        label.stringValue = isRecording ? "Type shortcut…" : currentCombination.displayString
        helper.stringValue = isRecording ? "Press Esc to cancel" : title
    }
}
