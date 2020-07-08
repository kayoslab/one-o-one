import UIKit

/**
  Data that will be directed out of the `PurchaseMenuViewController`
  to the  `PurchaseMenuInteractor`.
 */
protocol PurchaseMenuViewControllerOutput {

    /// The `PurchaseMenuViewController`'s view finished loading.
    func viewLoaded()

    /// The user's input changed and therefore the model
    /// needs an update (e.g. for validation).
    ///
    /// - Parameter viewModel: The model representing the
    ///                    current state of the userinterface.
    func viewContentUpdated(with viewModel: PurchaseMenuViewModel)
}

/**
  The `PurchaseMenuViewController` communicates with the `PurchaseMenuInteractor,
  and gets a response back from the `PurchaseMenuPresenter`.
 */
final class PurchaseMenuViewController: UIViewController {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: PurchaseMenuViewControllerOutput!

    // MARK: - Initializers

    /// This will initialise the `PurchaseMenuViewController` using a decoder object.
    /// To configure the relations in VIP, we'll use the default configure
    /// implementation using the `PurchaseMenuConfigurator`.
    ///
    /// - Parameter aDecoder: An unarchiver object.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        PurchaseMenuConfigurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewLoaded()
    }
}

// MARK: - PurchaseMenuPresenterOutput

extension PurchaseMenuViewController: PurchaseMenuPresenterOutput {

    // MARK: - Display logic

    func update(with viewModel: PurchaseMenuViewModel) {

    }
}
