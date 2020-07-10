import UIKit

/// A game consists of multiple chapters.
/// Each chapter consists of multiple Levels.
/// This results in the tree:
///
/// Game (x)
/// \ -------------> Chapter (y)
///           \ -------------> Level (z)
enum Game: CaseIterable {

    case additions
    case subtractions
    case multiplications
    case divisions

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

    var purchaseable: Bool {
        switch self {
        case .additions:
            return false
        case .subtractions:
            return true
        case .multiplications:
            return true
        case .divisions:
            return true
        }
    }

    var isPurchased: Bool {
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

    var backgroundColor: UIColor {
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


enum Level {
    case basic(Chapter)
    case intermediate(Chapter)
    case expert(Chapter)
    case deity(Chapter)
}

enum Chapter: Int {
    case first
    case second
    case third
    case fourth
    case fifth
    case sigth
    case seventh
    case eight
    case ninth
    case tenth
}
