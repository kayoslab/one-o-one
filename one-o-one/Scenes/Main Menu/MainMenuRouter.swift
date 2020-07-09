import UIKit

/**
  All the methods used for routing are kept under this protocol.
 */
protocol MainMenuRouterProtocol: class {

    var viewController: MainMenuViewController? { get }

    /// Display a purchase menu instead of the given game. This means
    /// the user was not allowed to see the game content without purchasing
    /// the necessary data.
    ///
    /// - Parameter game: The game that was requested by the user.
    func displayPurchaseMenu(with game: Game)

    /// Display a game module with a given game.
    ///
    /// - Parameter game: The game that was requested by the user.
    func displayNewGameLevel(game: Game)
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
    func displayPurchaseMenu(with game: Game) {
        let purchase = StoryboardScene.PurchaseMenu.initialScene
            .instantiate()
        purchase.modalPresentationStyle = .overFullScreen
        viewController?.present(
            purchase,
            animated: true,
            completion: nil
        )
    }

    func displayNewGameLevel(game: Game) {
        let game = StoryboardScene.Game.initialScene
            .instantiate()
        game.modalPresentationStyle = .overFullScreen
        viewController?.present(
            game,
            animated: true,
            completion: nil
        )
    }
}
