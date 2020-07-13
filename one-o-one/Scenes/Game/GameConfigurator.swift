import UIKit

/**
  Helper service that configures a `GameViewController` with the
  necessary CleanArchitecture reference classes.
 */
final class GameConfigurator {

    /// Configures a given `GameViewController` with
    /// the necessary reference.
    ///
    /// - Parameter viewController: The view controller to be configured.
    static func configure(viewController: GameViewController) {
        let router = GameRouter(viewController: viewController)
        let presenter = GamePresenter(output: viewController, router: router)
        let interactor = GameInteractor(output: presenter)

        viewController.output = interactor
    }
}
