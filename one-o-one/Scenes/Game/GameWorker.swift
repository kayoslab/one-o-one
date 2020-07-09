import UIKit

/**
 Data that will be directed towards the `GameWorker` coming 
 from the `GameInteractor`.
 */
protocol GameWorkerInput: class {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: GameWorkerOutput! { get set }

    func doSomeWork()
}

/**
 Data that will be directed out of the `GameWorker` to the
 `GameInteractor`. This protocol is used to return data
 from the worker.
 */
protocol GameWorkerOutput: class {

    func didSomeWork()
}

/**
  The `GameWorker` component will handle all the API/Data requests
  and responses. The Response struct will get the data ready for the
  `GameInteractor`. It will also handle the success/error response,
  so the `GameInteractor` knows how to proceed.
 */
class GameWorker: GameWorkerInput {

    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var output: GameWorkerOutput!

    // MARK: - Initializers

    /// This will initialize the `GameWorker` using
    /// a given `GameWorkerOutput`.
    ///
    /// - Parameter output: A reference to the used output.
    init(output: GameWorkerOutput? = nil) {
        if let output = output {
            self.output = output
        }
    }

    func doSomeWork() {
        output.didSomeWork()
    }
}
