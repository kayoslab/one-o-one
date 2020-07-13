import UIKit

/**
  Helper service that configures a `MainMenuViewController` with the
  necessary CleanArchitecture reference classes.
 */
final class MainMenuConfigurator {

    /// Configures a given `MainMenuViewController` with
    /// the necessary reference.
    ///
    /// - Parameter viewController: The view controller to be configured.
    static func configure(viewController: MainMenuViewController) {
        let router = MainMenuRouter(viewController: viewController)
        let presenter = MainMenuPresenter(output: viewController, router: router)
        let interactor = MainMenuInteractor(output: presenter)

        viewController.output = interactor
    }
}
