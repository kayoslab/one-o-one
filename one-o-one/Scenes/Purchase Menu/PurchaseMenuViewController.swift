import UIKit

/**
  Data that will be directed out of the `PurchaseMenuViewController`
  to the  `PurchaseMenuInteractor`.
 */
protocol PurchaseMenuViewControllerOutput {

    /// The `PurchaseMenuViewController`'s view finished loading.
    func viewLoaded()

    /// The user's has selected the close button.
    func closeButtonSelected()
}

/**
  The `PurchaseMenuViewController` communicates with the `PurchaseMenuInteractor,
  and gets a response back from the `PurchaseMenuPresenter`.
 */
final class PurchaseMenuViewController: UIViewController {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: PurchaseMenuViewControllerOutput!

    /// The `UIStackView` that contains prominently displayed items that are shown in the
    /// purchase menu. This stack view needs to be filled with menu items.
    @IBOutlet private weak var prominentItemsStackView: UIStackView?
    /// The `UIStackView` that contains regularly displayed items that are shown in the
    /// purchase menu. This stack view needs to be filled with menu items.
    @IBOutlet private weak var regularItemsStackView: UIStackView?

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

    @IBAction private func closeButtonTouched() {
        output.closeButtonSelected()
    }

    /// Reload the stack views entries based on the available game items.
    /// This will automatically add the arranged subviews and request them
    /// to update their view autonomously.
    private func reloadData(with viewModel: PurchaseMenuViewModel) {
        guard
            let prominentItemsStackView = self.prominentItemsStackView,
            let regularItemsStackView = self.regularItemsStackView
        else { return }

        prominentItemsStackView.arrangedSubviews.forEach(
            prominentItemsStackView.removeArrangedSubview
        )
        regularItemsStackView.arrangedSubviews.forEach(
            regularItemsStackView.removeArrangedSubview
        )

        for index in 0..<viewModel.featuredProducts.count {
            guard let product = viewModel.featuredProducts[safe: index] else { continue }

            let itemView: PurchaseMenuItemView = .fromNib()
            itemView.update(with: .init(with: product, index: index))
            prominentItemsStackView.addArrangedSubview(itemView)
        }

        for index in 0..<viewModel.regularProducts.count {
            guard let product = viewModel.regularProducts[safe: index] else { continue }

            let itemView: PurchaseMenuItemView = .fromNib()
            itemView.update(with: .init(with: product, index: index))
            regularItemsStackView.addArrangedSubview(itemView)
        }
    }
}

// MARK: - PurchaseMenuPresenterOutput

extension PurchaseMenuViewController: PurchaseMenuPresenterOutput {

    // MARK: - Display logic

    func update(with viewModel: PurchaseMenuViewModel) {
        reloadData(with: viewModel)
    }
}
