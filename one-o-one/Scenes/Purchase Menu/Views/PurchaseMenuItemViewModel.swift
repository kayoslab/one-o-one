import UIKit

struct PurchaseMenuItemViewModel {
    private let productItem: Product
    let index: Int

    var backgroundColor: UIColor {
        let gold = UIColor(
            red: 0.83,
            green: 0.68,
            blue: 0.21,
            alpha: 1.0
        )

        if productItem.included.count > 1 {
            return gold
        } else {
            return productItem.included.first?.backgroundColor ?? gold
        }
    }

    init(with productItem: Product, index: Int) {
        self.productItem = productItem
        self.index = index
    }
}
