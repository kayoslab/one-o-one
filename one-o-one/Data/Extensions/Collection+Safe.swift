import Foundation

extension Collection {
    /// Safe subscription for collection elements.
    ///
    /// - Parameter safe: The index of which the element should be returned.
    /// - Returns: The element at the given index if present, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
