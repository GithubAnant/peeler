import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let appState = AppState()
    private let permissionService = ScreenCapturePermissionService()
    private let colorSampler = ColorSamplerService()
    private let screenshotService = ScreenshotCaptureService()
    private let paletteExtractor = PaletteExtractionService()
    private let hotKeyController = HotKeyController()

    private var statusBarController: StatusBarController?
    private var windowRouter: WindowRouter?
    private var hudController: HUDPanelController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        appState.updater.start()
        hudController = HUDPanelController()
        windowRouter = WindowRouter(appState: appState)
        statusBarController = StatusBarController(
            appState: appState,
            onOpenPanel: { [weak self] in self?.showPanel() },
            onTogglePanel: { [weak self] in self?.togglePanel() },
            onOpenHistory: { [weak self] in self?.windowRouter?.showHistory() },
            onOpenPalettes: { [weak self] in self?.windowRouter?.showSavedPalettes() },
            onOpenSettings: { [weak self] in self?.windowRouter?.showSettings() }
        )

        appState.triggerEyedropper = { [weak self] in
            self?.startEyedropper()
        }
        appState.triggerPaletteCapture = { [weak self] in
            self?.startPaletteCapture()
        }
        appState.openSettingsWindow = { [weak self] in
            self?.windowRouter?.showSettings()
        }
        appState.openHistoryWindow = { [weak self] in
            self?.windowRouter?.showHistory()
        }
        appState.openSavedPalettesWindow = { [weak self] in
            self?.windowRouter?.showSavedPalettes()
        }
        appState.openPrivacySettings = { [weak self] in
            self?.permissionService.openPrivacySettings()
        }
        appState.onHotKeySettingsChanged = { [weak self] in
            self?.registerHotKeys()
        }
        appState.presentHUD = { [weak self] payload in
            guard let self else { return }
            self.hudController?.show(
                payload: payload,
                anchorFrame: self.statusBarController?.statusItemFrameInScreen
            )
        }

        registerHotKeys()
        applyAppearance(for: appState.settings.theme)
    }

    func applicationWillTerminate(_ notification: Notification) {}

    private func registerHotKeys() {
        if appState.settings.eyedropperHotkey == appState.settings.paletteHotkey {
            appState.hotKeyConflictMessage = "Eyedropper and palette shortcuts cannot use the same key combination."
            return
        }

        let eyedropperRegistered = hotKeyController.register(
            kind: .eyedropper,
            combination: appState.settings.eyedropperHotkey
        ) { [weak self] in
            Task { @MainActor in
                self?.startEyedropper()
            }
        }

        let paletteRegistered = hotKeyController.register(
            kind: .palette,
            combination: appState.settings.paletteHotkey
        ) { [weak self] in
            Task { @MainActor in
                self?.startPaletteCapture()
            }
        }

        if !eyedropperRegistered || !paletteRegistered {
            appState.hotKeyConflictMessage = "One or more hotkeys could not be registered. Open Settings and choose a different combination."
        } else {
            appState.hotKeyConflictMessage = nil
        }
    }

    private func startEyedropper() {
        guard ensureScreenPermission() else { return }
        statusBarController?.closePanel()

        colorSampler.pickColor { [weak self] color in
            guard let color else { return }
            self?.appState.handlePickedColor(color)
        }
    }

    private func startPaletteCapture() {
        guard ensureScreenPermission() else { return }
        statusBarController?.closePanel()

        Task { @MainActor [weak self] in
            guard let self else { return }
            guard let image = screenshotService.captureInteractiveRegion() else { return }
            let colors = await paletteExtractor.extractPalette(from: image, count: appState.settings.paletteColorCount)
            appState.handlePaletteCapture(image: image, colors: colors)
            showPanel()
        }
    }

    private func ensureScreenPermission() -> Bool {
        guard permissionService.requestIfNeeded() else {
            presentPermissionAlert()
            return false
        }
        return true
    }

    private func presentPermissionAlert() {
        let alert = NSAlert()
        alert.messageText = "Screen Recording Access Required"
        alert.informativeText = """
        Peeler needs Screen Recording permission to sample colors and \
        capture palettes from your display.\n\n\
        If you already granted permission but it's not working, try \
        toggling Peeler off and back on in System Settings → Privacy \
        & Security → Screen Recording.
        """
        alert.addButton(withTitle: "Open Privacy Settings")
        alert.addButton(withTitle: "Quit Peeler")
        alert.addButton(withTitle: "Cancel")

        switch alert.runModal() {
        case .alertFirstButtonReturn:
            permissionService.openPrivacySettings()
        case .alertSecondButtonReturn:
            NSApp.terminate(nil)
        default:
            break
        }
    }

    private func togglePanel() {
        statusBarController?.togglePanel()
    }

    private func showPanel() {
        statusBarController?.showPanel()
    }

    private func applyAppearance(for theme: AppTheme) {
        switch theme {
        case .system:
            NSApp.appearance = nil
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        }
    }
}
