import UIKit

/// A game consists of multiple chapters.
/// Each chapter consists of multiple Levels.
/// This results in the tree:
///
/// Game (x)
/// \ -------------> Chapter (y)
///           \ -------------> Level (z)
enum Game: CaseIterable {

    typealias AllCases = [Game]

    static var allCases: [Game] = [
        .addition(.basic(.first)),
        .substraction(.basic(.first)),
        .multiplication(.basic(.first)),
        .division(.basic(.first))
    ]

    case addition(Level)
    case substraction(Level)
    case multiplication(Level)
    case division(Level)

    var title: String {
        switch self {
        case .addition:
            return L10n.menuItemAddition
        case .substraction:
            return L10n.menuItemSubstraction
        case .multiplication:
            return L10n.menuItemMultiplication
        case .division:
            return L10n.menuItemDivision
        }
    }

    var purchaseable: Bool {
        switch self {
        case .addition:
            return false
        case .substraction:
            return true
        case .multiplication:
            return true
        case .division:
            return true
        }
    }

    var isPurchased: Bool {
        switch self {
        case .addition:
            return true
        case .substraction:
            return Purchased.subtractions
        case .multiplication:
            return Purchased.multiplications
        case .division:
            return Purchased.divisions
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .addition:
            return .green
        case .substraction:
            return .red
        case .multiplication:
            return .blue
        case .division:
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
