import UIKit

/**
  All the methods used for routing are kept under this protocol.
 */
protocol PurchaseMenuRouterProtocol: class {

    var viewController: PurchaseMenuViewController? { get }

}

/**
  The `PurchaseMenuRouter` takes care for the transition and passing
  data between view controllers.
 */
final class PurchaseMenuRouter {

    weak var viewController: PurchaseMenuViewController?

    // MARK: - Initializers

    /// This will initialize the `PurchaseMenuRouter` using
    /// an optional `PurchaseMenuViewController`.
    ///
    /// - Parameter viewController: A reference to the used view controller.
    init(viewController: PurchaseMenuViewController?) {
        self.viewController = viewController
    }
}

// MARK: - PurchaseMenuRouterProtocol

extension PurchaseMenuRouter: PurchaseMenuRouterProtocol {

}
