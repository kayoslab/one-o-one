import UIKit

// UIImage extension that creates a UIImage from a UIView
extension UIImage {

    /// Initialises an `UIImage`with a given `UIView`. This convenience
    /// initialiser might be usefull when trying to screenshot particular views.
    ///
    /// - Parameter view: The view which is the source of an image.
    convenience init? (view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        view.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }

        UIGraphicsEndImageContext()
        self.init(cgImage: image)
    }
}
