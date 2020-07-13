import UIKit

/// A list of possible games that can be played by the user. A `Game` represents
/// an entry in the main menu. Access to one or multiple games can be purchased
/// using a `Product`.
enum Game: CaseIterable {

    case additions
    case subtractions
    case multiplications
    case divisions

    /// The localised title of the game.
    var title: String {
        switch self {
        case .additions:
            return L10n.menuItemAdditions
        case .subtractions:
            return L10n.menuItemSubstractions
        case .multiplications:
            return L10n.menuItemMultiplications
        case .divisions:
            return L10n.menuItemDivisions
        }
    }

    /// Some games are already included in the initial package to
    /// give the  user an idea of what they can spend money on.
    var purchaseable: Bool {
        switch self {
        case .additions:
            return false
        default:
            return true
        }
    }

    /// Based on the purchase state this property provides the
    /// status if a user can start a game or first need to buy a
    /// `Product`.
    var isPlayable: Bool {
        switch self {
        case .additions:
            return true
        case .subtractions:
            return Purchased.subtractions
        case .multiplications:
            return Purchased.multiplications
        case .divisions:
            return Purchased.divisions
        }
    }

    /// The games primary color which can be used to style the
    /// game's tiles.
    var primaryColor: UIColor {
        switch self {
        case .additions:
            return .green
        case .subtractions:
            return .red
        case .multiplications:
            return .blue
        case .divisions:
            return .purple
        }
    }
}
