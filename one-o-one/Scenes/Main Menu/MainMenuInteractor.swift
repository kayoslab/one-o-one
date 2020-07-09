import UIKit

/**
  Data that will be directed out of the `MainMenuInteractor`
  to the `MainMenuPresenter`.
 */
protocol MainMenuInteractorOutput {

    /// Triggers an update with the new view model.
    ///
    /// - parameter viewModel: View model which will be applied. 
    func update(with viewModel: MainMenuViewModel)

    /// Present the requested game level to the user.
    ///
    /// - Parameter game: The game which was requested by the user.
    func presentLevel(for game: Game)

    /// Present the purchase menu for the requested game.
    ///
    /// - Parameter game: The game that the user tried to start.
    func presentPurchase(for game: Game)
}

/**
  This is the “mediator” between the `MainMenuWorker` and the `MainMenuPresenter`.
  First, it communicates with the `MainMenuViewController` which passes all
  the request params needed for the `MainMenuWorker`. Before proceeding
  to the `MainMenuWorker`, a validation is done to check
  if everything is sent properly. The `MainMenuWorker` returns a response
  and the `MainMenuInteractor` passes that response towards the `MainMenuPresenter.
 */
final class MainMenuInteractor {

    private let output: MainMenuInteractorOutput
    private let worker: MainMenuWorkerInput
    private var viewModel: MainMenuViewModel

    // MARK: - Initializers

    /// This will initialise the `MainMenuInteractor` using
    /// a given `MainMenuInteractorOutput` and `MainMenuWorker`.
    ///
    /// - Parameters:
    ///   - output: A reference to the used output.
    ///   - worker: A reference to the used worker
    ///
    /// - Note: The worker parameter's default value
    ///         is the `MainMenuWorker`.
    init(
        output: MainMenuInteractorOutput,
        worker: MainMenuWorkerInput = MainMenuWorker()
    ) {
        self.viewModel = .init()
        self.output = output
        self.worker = worker
        self.worker.output = self
    }
}

// MARK: - MainMenuViewControllerOutput

extension MainMenuInteractor: MainMenuViewControllerOutput {

    // MARK: - Business logic

    func viewLoaded() {
        output.update(with: viewModel)
    }

    func menuItemSelected(with index: Int) {
        guard let game = viewModel.games[safe: index] else {
            fatalError("The games should be present at this time.")
        }
        worker.requestPurchaseStatus(for: game)
    }
}

extension MainMenuInteractor: MainMenuWorkerOutput {
    func didReceivePurchaseStatus(for game: Game, purchased: Bool) {
        if purchased {
            output.presentLevel(for: game)
        } else {
            output.presentPurchase(for: game)
        }
    }
}
