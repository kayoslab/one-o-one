import UIKit

/**
  Data that will be directed out of the `PurchaseMenuPresenter` to the
  `PurchaseMenuViewController`. This protocol stores the presentation
  logic methods.
 */
protocol PurchaseMenuPresenterOutput: class {

    /// Triggers an update with the new view model.
    ///
    /// - parameter viewModel: View model which will be applied. 
    func update(with viewModel: PurchaseMenuViewModel)
}

/**
  Formats the response into a `PurchaseMenuViewModel` and pass the result back to
  the `PurchaseMenuViewController`. The `PurchaseMenuPresenter` will be in charge
  of the presentation logic. This component decides how the data will be
  presented to the user. Also, when there is a need for transition, it will 
  communicate with the `PurchaseMenuRouter`.
 */
final class PurchaseMenuPresenter {

    private(set) unowned var output: PurchaseMenuPresenterOutput
    private(set) var router: PurchaseMenuRouterProtocol

    // MARK: - Initializers

    /// This will initialize the `PurchaseMenuPresenter` using
    /// a given `PurchaseMenuPresenterOutput` and `PurchaseMenuRouter`.
    ///
    /// - Parameter output: A reference to the used output.
    /// - Parameter router: A reference to the used router.
    init(output: PurchaseMenuPresenterOutput, router: PurchaseMenuRouterProtocol) {
        self.output = output
        self.router = router
    }
}

// MARK: - PurchaseMenuInteractorOutput

extension PurchaseMenuPresenter: PurchaseMenuInteractorOutput {

    // MARK: - Presentation logic

    func update(with viewModel: PurchaseMenuViewModel) {
        output.update(with: viewModel)
    }

    func closePurchaseMenu() {
        router.dismissPurchaseMenu()
    }
}
