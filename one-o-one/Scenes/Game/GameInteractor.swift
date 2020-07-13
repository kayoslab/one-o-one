import UIKit

/**
  Data that will be directed out of the `GameInteractor`
  to the `GamePresenter`.
 */
protocol GameInteractorOutput {
    /// Triggers an update with the new view model.
    ///
    /// - parameter viewModel: View model which will be applied.
    func update(with viewModel: GameViewModel)

    /// Triggers a close operation for the purchase menu.
    func closeGameLevel()
}

/**
  This is the “mediator” between the `GameWorker` and the `GamePresenter`.
  First, it communicates with the `GameViewController` which passes all
  the request params needed for the `GameWorker`. Before proceeding
  to the `GameWorker`, a validation is done to check
  if everything is sent properly. The `GameWorker` returns a response
  and the `GameInteractor` passes that response towards the `GamePresenter.
 */
final class GameInteractor {

    private let output: GameInteractorOutput
    private let worker: GameWorkerInput
    private var viewModel: GameViewModel

    // MARK: - Initializers

    /// This will initialise the `GameInteractor` using
    /// a given `GameInteractorOutput` and `GameWorker`.
    ///
    /// - Parameters:
    ///   - output: A reference to the used output.
    ///   - worker: A reference to the used worker
    ///
    /// - Note: The worker parameter's default value
    ///         is the `GameWorker`.
    init(
        output: GameInteractorOutput,
        worker: GameWorkerInput = GameWorker()
    ) {
        self.viewModel = .init()
        self.output = output
        self.worker = worker
        self.worker.output = self
    }
}

// MARK: - GameViewControllerOutput

extension GameInteractor: GameViewControllerOutput {

    // MARK: - Business logic

    func viewLoaded() {
        output.update(with: viewModel)
    }

    func closeButtonSelected() {
        output.closeGameLevel()
    }
}

extension GameInteractor: GameWorkerOutput {

    func didSomeWork() {

    }
}
