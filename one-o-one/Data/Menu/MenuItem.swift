import Foundation

enum MenuItem {
    case addition
    case substraction
    case multiplication
    case division

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

    var isPurcased: Bool {
        if purchaseable {
            // TODO: Return based on local/remote purchase state.
            return false
        } else {
            return true
        }
    }
}
