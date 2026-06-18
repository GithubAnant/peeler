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
    private var pendingPaletteCaptureTask: Task<Void, Never>?
    private var isPaletteCaptureActive = false

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
            hotKeyController.unregister(kind: .eyedropper)
            hotKeyController.unregister(kind: .palette)
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
        // NSColorSampler runs in a trusted system process and does not require
        // Peeler to hold the Screen Recording permission, so no preflight gate here.
        statusBarController?.closePanel()

        colorSampler.pickColor { [weak self] color in
            guard let color else { return }
            self?.appState.handlePickedColor(color)
        }
    }

    private func startPaletteCapture() {
        guard !isPaletteCaptureActive, pendingPaletteCaptureTask == nil else { return }
        // `screencapture -i` is a user-mediated system tool that captures to the
        // clipboard without requiring Peeler's own Screen Recording grant.
        statusBarController?.closePanel()

        isPaletteCaptureActive = true
        pendingPaletteCaptureTask = Task { @MainActor [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 150_000_000)
            self.pendingPaletteCaptureTask = nil
            guard !Task.isCancelled else {
                self.isPaletteCaptureActive = false
                return
            }

            defer {
                self.isPaletteCaptureActive = false
            }

            guard let image = screenshotService.captureInteractiveRegion() else { return }
            let colors = await paletteExtractor.extractPalette(from: image, count: appState.settings.paletteColorCount)
            appState.handlePaletteCapture(image: image, colors: colors)
            showPanel()
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
