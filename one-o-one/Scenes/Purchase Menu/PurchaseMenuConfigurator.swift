import UIKit

/**
  Helper service that configures a `PurchaseMenuViewController` with the
  necessary CleanArchitecture reference classes.
 */
final class PurchaseMenuConfigurator {

    /// Configures a given `PurchaseMenuViewController` with
    /// the necessary reference.
    ///
    /// - Parameter viewController: The view controller to be configured.
    static func configure(viewController: PurchaseMenuViewController) {
        let router = PurchaseMenuRouter(viewController: viewController)
        let presenter = PurchaseMenuPresenter(output: viewController, router: router)
        let interactor = PurchaseMenuInteractor(output: presenter)

        viewController.output = interactor
    }
}
