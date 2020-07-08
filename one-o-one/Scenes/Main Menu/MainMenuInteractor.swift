import UIKit

/**
  Data that will be directed out of the `MainMenuInteractor`
  to the `MainMenuPresenter`.
 */
protocol MainMenuInteractorOutput {

    /// Updates the view controller after the view is loaded.
    func presentUpdateAfterLoading()

    /// Triggers an update with the new view model.
    ///
    /// - parameter viewModel: View model which will be applied. 
    func update(with viewModel: MainMenuViewModel)
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
        self.output = output
        self.worker = worker
        self.worker.output = self
    }
}

// MARK: - MainMenuViewControllerOutput

extension MainMenuInteractor: MainMenuViewControllerOutput {

    // MARK: - Business logic

    func viewLoaded() {
        output.presentUpdateAfterLoading()
    }

    func viewContentUpdated(with viewModel: MainMenuViewModel) {
        output.update(with: viewModel)
    }
}

extension MainMenuInteractor: MainMenuWorkerOutput { }
