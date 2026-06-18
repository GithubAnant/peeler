import AppKit

@MainActor
final class ColorSamplerService {
    private var sampler: NSColorSampler?
    private var pendingPickTask: Task<Void, Never>?

    func pickColor(completion: @escaping (NSColor?) -> Void) {
        guard sampler == nil, pendingPickTask == nil else { return }

        pendingPickTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 150_000_000)
            guard let self, !Task.isCancelled else { return }

            self.pendingPickTask = nil

            let sampler = NSColorSampler()
            self.sampler = sampler
            sampler.show { [weak self] color in
                Task { @MainActor in
                    completion(color)
                    self?.sampler = nil
                }
            }
        }
    }

}
