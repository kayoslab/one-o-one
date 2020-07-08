import UIKit

/**
  Data that will be directed out of the `MainMenuPresenter` to the
  `MainMenuViewController`. This protocol stores the presentation
  logic methods.
 */
protocol MainMenuPresenterOutput: class {

    /// Triggers an update with the new view model.
    ///
    /// - parameter viewModel: View model which will be applied. 
    func update(with viewModel: MainMenuViewModel)
}

/**
  Formats the response into a `MainMenuViewModel` and pass the result back to
  the `MainMenuViewController`. The `MainMenuPresenter` will be in charge
  of the presentation logic. This component decides how the data will be
  presented to the user. Also, when there is a need for transition, it will 
  communicate with the `MainMenuRouter`.
 */
final class MainMenuPresenter {

    private(set) unowned var output: MainMenuPresenterOutput
    private(set) var router: MainMenuRouterProtocol

    // MARK: - Initializers

    /// This will initialize the `MainMenuPresenter` using
    /// a given `MainMenuPresenterOutput` and `MainMenuRouter`.
    ///
    /// - Parameter output: A reference to the used output.
    /// - Parameter router: A reference to the used router.
    init(output: MainMenuPresenterOutput, router: MainMenuRouterProtocol) {
        self.output = output
        self.router = router
    }
}

// MARK: - MainMenuInteractorOutput

extension MainMenuPresenter: MainMenuInteractorOutput {

    // MARK: - Presentation logic

    func presentUpdateAfterLoading() {
        let viewModel = MainMenuViewModel()
        update(with: viewModel)
    }

    func update(with viewModel: MainMenuViewModel) {
        output.update(with: viewModel)
    }
}
