import UIKit

/**
  Data that will be directed out of the `GameViewController`
  to the  `GameInteractor`.
 */
protocol GameViewControllerOutput {

    /// The `GameViewController`'s view finished loading.
    func viewLoaded()

    /// Injects a requested `Game` into the module to know which game
    /// is relevant for the user.
    ///
    /// - Parameter requestedGame: The game, which the user wants
    ///                            to run.
    func inject(requested requestedGame: Game)

    /// The user's has selected the close button.
    func closeButtonSelected()
}

/**
  The `GameViewController` communicates with the `GameInteractor,
  and gets a response back from the `GamePresenter`.
 */
final class GameViewController: UIViewController {

    @IBOutlet private weak var leftCanvas: CanvasView?
    @IBOutlet private weak var rightCanvas: CanvasView?

    // Temporary result labels
    @IBOutlet private weak var leftResultLabel: UILabel?
    @IBOutlet private weak var rightResultLabel: UILabel?

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: GameViewControllerOutput!

    // MARK: - Initializers

    /// This will initialise the `GameViewController` using a decoder object.
    /// To configure the relations in VIP, we'll use the default configure
    /// implementation using the `GameConfigurator`.
    ///
    /// - Parameter aDecoder: An unarchiver object.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        GameConfigurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewLoaded()
    }

    @IBAction private func closeButtonTouched() {
        output.closeButtonSelected()
    }
}

// MARK: - GamePresenterOutput

extension GameViewController: GamePresenterOutput {

    // MARK: - Display logic

    func update(with viewModel: GameViewModel) {
        leftCanvas?.output = leftResultLabel
        rightCanvas?.output = rightResultLabel
    }
}
