import Combine
import Foundation

#if canImport(Sparkle)
import Sparkle
#endif

@MainActor
final class AppUpdateController: ObservableObject {
    @Published private(set) var automaticallyChecksForUpdates = false
    @Published private(set) var automaticallyDownloadsUpdates = false
    @Published private(set) var canCheckForUpdates = false
    @Published private(set) var isConfigured = false
    @Published private(set) var statusDescription = "Updater not configured."

    let feedURL: URL?

    private let publicEDKey: String?

    #if canImport(Sparkle)
    private var updaterController: SPUStandardUpdaterController?
    private var observations: [NSKeyValueObservation] = []
    #endif

    init(bundle: Bundle = .main) {
        let infoDictionary = bundle.infoDictionary ?? [:]
        feedURL = URL(string: infoDictionary["SUFeedURL"] as? String ?? "")
        publicEDKey = infoDictionary["SUPublicEDKey"] as? String

        if feedURL == nil {
            statusDescription = "Missing SUFeedURL in Info.plist."
        } else if !Self.hasConfiguredPublicKey(publicEDKey) {
            statusDescription = "Missing SUPublicEDKey in Info.plist."
        } else {
            isConfigured = true
            statusDescription = "Sparkle is configured and ready."
        }

        #if !canImport(Sparkle)
        statusDescription = "Sparkle dependency is not available in this build."
        #endif
    }

    func start() {
        guard isConfigured else { return }

        #if canImport(Sparkle)
        guard updaterController == nil else { return }

        let controller = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        updaterController = controller
        bind(to: controller.updater)
        #endif
    }

    func setAutomaticallyChecksForUpdates(_ enabled: Bool) {
        #if canImport(Sparkle)
        guard let updater = updaterController?.updater else { return }
        updater.automaticallyChecksForUpdates = enabled
        if !enabled, updater.automaticallyDownloadsUpdates {
            updater.automaticallyDownloadsUpdates = false
        }
        refresh(from: updater)
        #endif
    }

    func setAutomaticallyDownloadsUpdates(_ enabled: Bool) {
        #if canImport(Sparkle)
        guard let updater = updaterController?.updater else { return }
        updater.automaticallyDownloadsUpdates = enabled
        refresh(from: updater)
        #endif
    }

    func checkForUpdates() {
        #if canImport(Sparkle)
        updaterController?.checkForUpdates(nil)
        #endif
    }

    private static func hasConfiguredPublicKey(_ key: String?) -> Bool {
        guard let trimmed = key?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty else {
            return false
        }
        return !trimmed.contains("__")
    }

    #if canImport(Sparkle)
    private func bind(to updater: SPUUpdater) {
        observations = [
            updater.observe(\.canCheckForUpdates, options: [.initial, .new]) { [weak self] updater, _ in
                Task { @MainActor [weak self] in
                    self?.refresh(from: updater)
                }
            },
            updater.observe(\.automaticallyChecksForUpdates, options: [.initial, .new]) { [weak self] updater, _ in
                Task { @MainActor [weak self] in
                    self?.refresh(from: updater)
                }
            },
            updater.observe(\.automaticallyDownloadsUpdates, options: [.initial, .new]) { [weak self] updater, _ in
                Task { @MainActor [weak self] in
                    self?.refresh(from: updater)
                }
            },
        ]
    }

    private func refresh(from updater: SPUUpdater) {
        canCheckForUpdates = updater.canCheckForUpdates
        automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
        automaticallyDownloadsUpdates = updater.automaticallyDownloadsUpdates
    }
    #endif
}
