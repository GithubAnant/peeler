import AppKit

extension NSImage {
    func thumbnailJPEGData(maxDimension: CGFloat) -> Data? {
        let size = self.size
        let scale = min(maxDimension / max(size.width, 1), maxDimension / max(size.height, 1), 1)
        let targetSize = NSSize(width: size.width * scale, height: size.height * scale)
        let image = NSImage(size: targetSize)
        image.lockFocus()
        draw(in: NSRect(origin: .zero, size: targetSize))
        image.unlockFocus()

        guard
            let tiff = image.tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiff)
        else {
            return nil
        }

        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.8])
    }
}
