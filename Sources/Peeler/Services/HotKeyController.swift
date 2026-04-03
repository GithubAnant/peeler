import Carbon
import Foundation

enum HotKeyKind: UInt32 {
    case eyedropper = 1
    case palette = 2
}

@MainActor
final class HotKeyController {
    private var handlerRef: EventHandlerRef?
    private var hotKeyRefs: [HotKeyKind: EventHotKeyRef?] = [:]
    private var actions: [HotKeyKind: () -> Void] = [:]

    init() {
        installHandler()
    }

    func register(kind: HotKeyKind, combination: HotKeyCombination, action: @escaping () -> Void) -> Bool {
        unregister(kind: kind)

        let hotKeyID = EventHotKeyID(signature: fourCharCode("PEEL"), id: kind.rawValue)
        var ref: EventHotKeyRef?
        let status = RegisterEventHotKey(
            combination.keyCode,
            combination.carbonModifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &ref
        )

        guard status == noErr else {
            return false
        }

        hotKeyRefs[kind] = ref
        actions[kind] = action
        return true
    }

    func unregister(kind: HotKeyKind) {
        if let ref = hotKeyRefs[kind] ?? nil {
            UnregisterEventHotKey(ref)
        }
        hotKeyRefs.removeValue(forKey: kind)
        actions.removeValue(forKey: kind)
    }

    private func installHandler() {
        var eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(
            GetApplicationEventTarget(),
            { _, eventRef, userData in
                guard
                    let userData,
                    let eventRef
                else {
                    return noErr
                }

                let controller = Unmanaged<HotKeyController>.fromOpaque(userData).takeUnretainedValue()
                var hotKeyID = EventHotKeyID()
                let status = GetEventParameter(
                    eventRef,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )

                guard status == noErr, let kind = HotKeyKind(rawValue: hotKeyID.id) else {
                    return status
                }

                controller.actions[kind]?()
                return noErr
            },
            1,
            &eventSpec,
            Unmanaged.passUnretained(self).toOpaque(),
            &handlerRef
        )
    }

    private func fourCharCode(_ value: String) -> OSType {
        value.utf8.reduce(0) { ($0 << 8) + OSType($1) }
    }
}
