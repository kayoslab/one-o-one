import UIKit

/**
  Stores all the models related to the `PurchaseMenuViewController`.
  The `PurchaseMenuViewModel's` class will be related to each component.
  The view model will contain Request, Response and ViewModel structs.
 */
struct PurchaseMenuViewModel {
    /// The regular list of products.
    var featuredProducts: [Product] = [
        .subtractions,
        .multiplications,
        .divisions
    ]
    /// A more prominent list of products.
    var regularProducts: [Product] = [
        .fullPackage
    ]
    
    var unsuccessfulPurchase: Product?
    
    init(with unsuccessfulPurchase: Product? = nil) {
        self.unsuccessfulPurchase = unsuccessfulPurchase
    }
}
