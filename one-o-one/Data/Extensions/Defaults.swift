import Foundation

let defaults = UserDefaults(suiteName: "one_o_one")

@propertyWrapper
struct UserDefault<T> {
    let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            return defaults?.object(forKey: key) as? T
        }
        set {
            defaults?.set(newValue, forKey: key)
        }
    }
}
