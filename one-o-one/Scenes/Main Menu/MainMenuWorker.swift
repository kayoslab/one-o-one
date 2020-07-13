import UIKit

enum MainMenuWorkerError: Error {
    case notPurchased(Game)
}

/**
 Data that will be directed towards the `MainMenuWorker` coming 
 from the `MainMenuInteractor`.
 */
protocol MainMenuWorkerInput: class {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: MainMenuWorkerOutput! { get set }

    /// Request if a game item needs to be purchased before it can be
    /// played by the user. This function will trigger a call of the
    /// `didReceiveAvailability` when the information was
    /// retrieved.
    ///
    /// - Parameter game: The game for which the availability
    ///                   status was requested.
    func requestAvailability(for game: Game)
}

/**
 Data that will be directed out of the `MainMenuWorker` to the
 `MainMenuInteractor`. This protocol is used to return data
 from the worker.
 */
protocol MainMenuWorkerOutput: class {

    /// The availability status for a requested game was received from the
    /// `PurchaseManager` and is passed along as payload.
    ///
    /// - Parameters:
    ///   - game: The game that was requested.
    ///   - available: Indicates if the game is playable.
    func didReceiveAvailability(with result: Result<Game, MainMenuWorkerError>)
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

    func requestAvailability(for game: Game) {
        if game.isPlayable {
            output.didReceiveAvailability(
                with: .success(game)
            )
        } else {
            output.didReceiveAvailability(
                with: .failure(
                    .notPurchased(game)
                )
            )
        }
    }
}
