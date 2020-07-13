import UIKit

/**
  Data that will be directed out of the `GamePresenter` to the
  `GameViewController`. This protocol stores the presentation
  logic methods.
 */
protocol GamePresenterOutput: class {

    /// Triggers an update with the new view model.
    ///
    /// - parameter viewModel: View model which will be applied.
    func update(with viewModel: GameViewModel)
}

/**
  Formats the response into a `GameViewModel` and pass the result back to
  the `GameViewController`. The `GamePresenter` will be in charge
  of the presentation logic. This component decides how the data will be
  presented to the user. Also, when there is a need for transition, it will
  communicate with the `GameRouter`.
 */
final class GamePresenter {

    private(set) unowned var output: GamePresenterOutput
    private(set) var router: GameRouterProtocol

    // MARK: - Initializers

    /// This will initialize the `GamePresenter` using
    /// a given `GamePresenterOutput` and `GameRouter`.
    ///
    /// - Parameter output: A reference to the used output.
    /// - Parameter router: A reference to the used router.
    init(output: GamePresenterOutput, router: GameRouterProtocol) {
        self.output = output
        self.router = router
    }
}

// MARK: - GameInteractorOutput

extension GamePresenter: GameInteractorOutput {

    // MARK: - Presentation logic

    func update(with viewModel: GameViewModel) {
        output.update(with: viewModel)
    }

    func closeGameLevel() {
        router.dismissGameLevel()
    }
}
