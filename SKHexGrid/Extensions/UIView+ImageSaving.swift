import Foundation
import UIKit

extension UIView {
    func snapshotImage(withSize size: CGSize) -> UIImage? {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = isOpaque
        rendererFormat.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        return renderer.image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
}

extension UIImage {
    func saveToPhotoLibrary(_ completionTarget: Any?, _ completionSelector: Selector?) {
        DispatchQueue.global(qos: .userInitiated).async {
            UIImageWriteToSavedPhotosAlbum(self, completionTarget, completionSelector, nil)
        }
    }
}

