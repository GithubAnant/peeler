import AppKit
import Foundation

@MainActor
struct ScreenshotCaptureService {
    func captureInteractiveRegion() -> NSImage? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        process.arguments = ["-i", "-c"]

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return nil
        }

        guard process.terminationStatus == 0 else {
            return nil
        }

        return NSPasteboard.general.readObjects(forClasses: [NSImage.self])?.first as? NSImage
    }
}
