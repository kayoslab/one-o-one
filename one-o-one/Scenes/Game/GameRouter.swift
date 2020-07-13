import UIKit

/**
  All the methods used for routing are kept under this protocol.
 */
protocol GameRouterProtocol: class {

    var viewController: GameViewController? { get }

    /// Dismiss the currently displayed purchase menu with animation.
    ///
    func dismissGameLevel()
}

/**
  The `GameRouter` takes care for the transition and passing
  data between view controllers.
 */
final class GameRouter {

    weak var viewController: GameViewController?

    // MARK: - Initializers

    /// This will initialize the `GameRouter` using
    /// an optional `GameViewController`.
    ///
    /// - Parameter viewController: A reference to the used view controller.
    init(viewController: GameViewController?) {
        self.viewController = viewController
    }
}

// MARK: - GameRouterProtocol

extension GameRouter: GameRouterProtocol {

    // MARK: - Navigation

    func dismissGameLevel() {
        viewController?.dismiss(
            animated: true,
            completion: nil
        )
    }
}
