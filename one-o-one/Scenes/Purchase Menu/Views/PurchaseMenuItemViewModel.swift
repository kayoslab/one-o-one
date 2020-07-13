import UIKit

struct PurchaseMenuItemViewModel {
    let product: Product
    private static let gold = UIColor(
        red: 0.83,
        green: 0.68,
        blue: 0.21,
        alpha: 1.0
    )

    var backgroundColor: UIColor {
        if product.included.count > 1 {
            return PurchaseMenuItemViewModel.gold
        } else {
            return product.included.first?.primaryColor ?? PurchaseMenuItemViewModel.gold
        }
    }

    init(with product: Product, index: Int) {
        self.product = product
    }
}
