import UIKit

/**
  All the methods used for routing are kept under this protocol.
 */
protocol MainMenuRouterProtocol: class {

    var viewController: MainMenuViewController? { get }

}

/**
  The `MainMenuRouter` takes care for the transition and passing
  data between view controllers.
 */
final class MainMenuRouter {

    weak var viewController: MainMenuViewController?

    // MARK: - Initializers

    /// This will initialize the `MainMenuRouter` using
    /// an optional `MainMenuViewController`.
    ///
    /// - Parameter viewController: A reference to the used view controller.
    init(viewController: MainMenuViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MainMenuRouterProtocol

extension MainMenuRouter: MainMenuRouterProtocol {

}
