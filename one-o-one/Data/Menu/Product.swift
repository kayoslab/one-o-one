import Foundation

/// A `Product` is a purchaseable item, which can contain one or
/// multiple games.
enum Product: String, CaseIterable {
    case fullPackage = "oneoone.fullpackage"
    case subtractions = "oneoone.subtractions"
    case multiplications = "oneoone.multiplications"
    case divisions = "oneoone.divisions"

    /// A list of games that are included in a `Product` purchase.
    var included: [Game] {
        switch self {
        case .fullPackage:
            return Game.allCases.filter { $0.purchaseable }
        case .subtractions:
            return [.subtractions]
        case .multiplications:
            return [.multiplications]
        case .divisions:
            return [.divisions]
        }
    }

    /// Indicates if this `Product` was already purchased by the user.
    var isPurchased: Bool {
        switch self {
        case .fullPackage:
            return Purchased.fullPackage
        case .subtractions:
            return Purchased.subtractions
        case .multiplications:
            return Purchased.multiplications
        case .divisions:
            return Purchased.divisions
        }
    }

    /// Update the locally persisted purchase status to make the app less
    /// dependent on a permanent network connection.
    ///
    /// - Parameter isPurchased: A boolean indicating if a `Product`
    ///                          was already purchased.
    /// - Note: This data is stored via the `Purchased.swift` file in
    ///         the UserDefaults. 
    func updatePurchaseStatus(isPurchased: Bool) {
        switch self {
        case .fullPackage:
            Purchased.fullPackage = isPurchased
        case .subtractions:
            Purchased.subtractions = isPurchased
        case .multiplications:
            Purchased.multiplications = isPurchased
        case .divisions:
            Purchased.divisions = isPurchased
        }
    }
}
