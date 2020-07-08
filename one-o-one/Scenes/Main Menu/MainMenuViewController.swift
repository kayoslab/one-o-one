import UIKit

/**
  Data that will be directed out of the `MainMenuViewController`
  to the  `MainMenuInteractor`.
 */
protocol MainMenuViewControllerOutput {

    /// The `MainMenuViewController`'s view finished loading.
    func viewLoaded()

    /// The user's input changed and therefore the model
    /// needs an update (e.g. for validation).
    ///
    /// - Parameter viewModel: The model representing the
    ///                    current state of the userinterface.
    func viewContentUpdated(with viewModel: MainMenuViewModel)
}

/**
  The `MainMenuViewController` communicates with the `MainMenuInteractor,
  and gets a response back from the `MainMenuPresenter`.
 */
final class MainMenuViewController: UIViewController {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: MainMenuViewControllerOutput!

    // MARK: - Initializers

    /// This will initialise the `MainMenuViewController` using a decoder object.
    /// To configure the relations in VIP, we'll use the default configure
    /// implementation using the `MainMenuConfigurator`.
    ///
    /// - Parameter aDecoder: An unarchiver object.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        MainMenuConfigurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewLoaded()
    }
}

// MARK: - MainMenuPresenterOutput

extension MainMenuViewController: MainMenuPresenterOutput {

    // MARK: - Display logic

    func update(with viewModel: MainMenuViewModel) {

    }
}
