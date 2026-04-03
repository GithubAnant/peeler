import AppKit
import CoreGraphics

struct ScreenCapturePermissionService {
    func hasPermission() -> Bool {
        CGPreflightScreenCaptureAccess()
    }

    func requestIfNeeded() -> Bool {
        if hasPermission() {
            return true
        }
        return CGRequestScreenCaptureAccess()
    }

    func openPrivacySettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture") else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}
