import UIKit

/**
 Data that will be directed towards the `MainMenuWorker` coming 
 from the `MainMenuInteractor`.
 */
protocol MainMenuWorkerInput: class {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: MainMenuWorkerOutput! { get set }
}

/**
 Data that will be directed out of the `MainMenuWorker` to the
 `MainMenuInteractor`. This protocol is used to return data
 from the worker.
 */
protocol MainMenuWorkerOutput: class {

}

/**
  The `MainMenuWorker` component will handle all the API/Data requests
  and responses. The Response struct will get the data ready for the
  `MainMenuInteractor`. It will also handle the success/error response,
  so the `MainMenuInteractor` knows how to proceed.
 */
class MainMenuWorker: MainMenuWorkerInput {

    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var output: MainMenuWorkerOutput!

    // MARK: - Initializers

    /// This will initialize the `MainMenuWorker` using
    /// a given `MainMenuWorkerOutput`.
    ///
    /// - Parameter output: A reference to the used output.
    init(output: MainMenuWorkerOutput? = nil) {
        if let output = output {
            self.output = output
        }
    }
}
