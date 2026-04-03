import AppKit

@MainActor
final class ColorSamplerService {
    private var sampler: NSColorSampler?

    func pickColor(completion: @escaping (NSColor?) -> Void) {
        let sampler = NSColorSampler()
        self.sampler = sampler
        sampler.show { [weak self] color in
            completion(color)
            self?.sampler = nil
        }
    }
}
