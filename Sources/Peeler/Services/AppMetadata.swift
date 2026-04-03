import Foundation

struct AppMetadata {
    let appName: String
    let displayName: String
    let version: String
    let build: String
    let releaseName: String?
    let bundleIdentifier: String
    let minimumSystemVersion: String
    let updateFeedURL: URL?
    let homepageURL: URL?
    let repositoryURL: URL?
    let authorName: String?
    let authorURL: URL?
    let copyright: String?
    let installPath: String

    var versionDescription: String {
        "\(version) (\(build))"
    }

    static func current(bundle: Bundle = .main) -> AppMetadata {
        let infoDictionary = bundle.infoDictionary ?? [:]
        let name = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Peeler"
        let displayName = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? name
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        let releaseName = infoDictionary["PeelerReleaseName"] as? String
        let bundleIdentifier = bundle.bundleIdentifier ?? "Unknown"
        let minimumSystemVersion = bundle.object(forInfoDictionaryKey: "LSMinimumSystemVersion") as? String ?? "13.0"
        let updateFeedURL = URL(string: infoDictionary["SUFeedURL"] as? String ?? "")
        let homepageURL = URL(string: infoDictionary["PeelerHomepageURL"] as? String ?? "")
        let repositoryURL = URL(string: infoDictionary["PeelerRepositoryURL"] as? String ?? "")
        let authorName = infoDictionary["PeelerAuthorName"] as? String
        let authorURL = URL(string: infoDictionary["PeelerAuthorURL"] as? String ?? "")
        let copyright = bundle.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
        let installPath = bundle.bundleURL.path

        return AppMetadata(
            appName: name,
            displayName: displayName,
            version: version,
            build: build,
            releaseName: releaseName,
            bundleIdentifier: bundleIdentifier,
            minimumSystemVersion: minimumSystemVersion,
            updateFeedURL: updateFeedURL,
            homepageURL: homepageURL,
            repositoryURL: repositoryURL,
            authorName: authorName,
            authorURL: authorURL,
            copyright: copyright,
            installPath: installPath
        )
    }
}
