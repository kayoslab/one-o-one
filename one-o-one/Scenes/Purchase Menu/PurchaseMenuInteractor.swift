import UIKit

/**
  Data that will be directed out of the `PurchaseMenuInteractor`
  to the `PurchaseMenuPresenter`.
 */
protocol PurchaseMenuInteractorOutput {

    /// Triggers an update with the new view model.
    ///
    /// - parameter viewModel: View model which will be applied. 
    func update(with viewModel: PurchaseMenuViewModel)

    /// Triggers a close operation for the purchase menu.
    func closePurchaseMenu()
}

/**
  This is the “mediator” between the `PurchaseMenuWorker` and the `PurchaseMenuPresenter`.
  First, it communicates with the `PurchaseMenuViewController` which passes all
  the request params needed for the `PurchaseMenuWorker`. Before proceeding
  to the `PurchaseMenuWorker`, a validation is done to check
  if everything is sent properly. The `PurchaseMenuWorker` returns a response
  and the `PurchaseMenuInteractor` passes that response towards the `PurchaseMenuPresenter.
 */
final class PurchaseMenuInteractor {

    private let output: PurchaseMenuInteractorOutput
    private let worker: PurchaseMenuWorkerInput
    private var viewModel: PurchaseMenuViewModel

    // MARK: - Initializers

    /// This will initialise the `PurchaseMenuInteractor` using
    /// a given `PurchaseMenuInteractorOutput` and `PurchaseMenuWorker`.
    ///
    /// - Parameters:
    ///   - output: A reference to the used output.
    ///   - worker: A reference to the used worker
    ///
    /// - Note: The worker parameter's default value
    ///         is the `PurchaseMenuWorker`.
    init(
        output: PurchaseMenuInteractorOutput,
        worker: PurchaseMenuWorkerInput = PurchaseMenuWorker()
    ) {
        self.viewModel = .init()
        self.output = output
        self.worker = worker
        self.worker.output = self
    }
}

// MARK: - PurchaseMenuViewControllerOutput

extension PurchaseMenuInteractor: PurchaseMenuViewControllerOutput {

    // MARK: - Business logic

    func viewLoaded() {
        output.update(with: viewModel)
    }

    func closeButtonSelected() {
        output.closePurchaseMenu()
    }

    func purchaseSelected(with product: Product) {
        worker.requestPurchase(for: product)
    }
}

extension PurchaseMenuInteractor: PurchaseMenuWorkerOutput {
    func didExecutePurchase(with result: Result<Product, PurchaseWorkerError>) {
        switch result {
        case .success:
            viewModel = .init()
            output.update(with: viewModel)
        case .failure(let error):
            if case let .unexpected(product) = error {
                viewModel = .init(with: product)
                output.update(with: viewModel)
            } else {
                assert(true, "Undefined error")
            }
        }
    }
}
