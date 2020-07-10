import Foundation

enum Product: String, CaseIterable {
    case fullPackage = "oneoone.fullpackage"
    case subtractions = "oneoone.subtractions"
    case multiplications = "oneoone.multiplications"
    case divisions = "oneoone.divisions"

    var included: [Game] {
        switch self {
        case .fullPackage:
            return Game.allCases.filter { $0.purchaseable }
        case .subtractions:
            return [
                .subtractions
            ]
        case .multiplications:
            return [
                .multiplications
            ]
        case .divisions:
            return [
                .divisions
            ]
        }
    }

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
}
