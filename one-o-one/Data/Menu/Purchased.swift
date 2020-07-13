import Foundation

/// Store if a `Product` was purchased
struct Purchased {
    // swiftlint:disable let_var_whitespace
    @UserDefault("oneoone.fullpackage")
    private static var purchasedFullPackage: Bool?

    @UserDefault("oneoone.subtractions")
    private static var purchasedSubtractions: Bool?

    @UserDefault("oneoone.multiplications")
    private static var purchasedMultiplications: Bool?

    @UserDefault("oneoone.divisions")
    private static var purchasedDivisions: Bool?
    // swiftlint:enable let_var_whitespace

    static var fullPackage: Bool {
        get {
            return Purchased.purchasedFullPackage ?? false
        }
        set {
            Purchased.purchasedFullPackage = newValue
        }
    }

    static var subtractions: Bool {
        get {
            if Purchased.purchasedFullPackage ?? false {
                return true
            }
            return Purchased.purchasedSubtractions ?? false
        }
        set {
            Purchased.purchasedSubtractions = newValue
        }
    }

    static var multiplications: Bool {
        get {
            if Purchased.purchasedFullPackage ?? false {
                return true
            }
            return Purchased.purchasedMultiplications ?? false
        }
        set {
            Purchased.purchasedMultiplications = newValue
        }
    }

    static var divisions: Bool {
        get {
            if Purchased.purchasedFullPackage ?? false {
                return true
            }
            return Purchased.purchasedDivisions ?? false
        }
        set {
            Purchased.purchasedMultiplications = newValue
        }
    }
}
