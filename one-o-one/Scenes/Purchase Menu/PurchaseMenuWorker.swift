import UIKit

/**
 Data that will be directed towards the `PurchaseMenuWorker` coming 
 from the `PurchaseMenuInteractor`.
 */
protocol PurchaseMenuWorkerInput: class {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: PurchaseMenuWorkerOutput! { get set }
}

/**
 Data that will be directed out of the `PurchaseMenuWorker` to the
 `PurchaseMenuInteractor`. This protocol is used to return data
 from the worker.
 */
protocol PurchaseMenuWorkerOutput: class {

}

/**
  The `PurchaseMenuWorker` component will handle all the API/Data requests
  and responses. The Response struct will get the data ready for the
  `PurchaseMenuInteractor`. It will also handle the success/error response,
  so the `PurchaseMenuInteractor` knows how to proceed.
 */
class PurchaseMenuWorker: PurchaseMenuWorkerInput {

    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var output: PurchaseMenuWorkerOutput!

    // MARK: - Initializers

    /// This will initialize the `PurchaseMenuWorker` using
    /// a given `PurchaseMenuWorkerOutput`.
    ///
    /// - Parameter output: A reference to the used output.
    init(output: PurchaseMenuWorkerOutput? = nil) {
        if let output = output {
            self.output = output
        }
    }
}
