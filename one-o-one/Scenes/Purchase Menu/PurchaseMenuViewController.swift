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

    /// The user has selected a purchaseable `Product`.
    ///
    /// - Parameter product: The underlying product retrieved from
    ///                      the `PurchaseMenuItemView`.
    func purchaseSelected(with product: Product)
}

/// An object to hold a relation between `Product` and `PurchaseMenuItemView`
/// over the course of the existence of a `PurchaseMenuItemViewController`.
/// This helps to retrieve the view for a product for further manipulation.
private struct PurchaseMenuItem {
    let product: Product
    weak var itemView: PurchaseMenuItemView?
}

/**
  The `PurchaseMenuViewController` communicates with the `PurchaseMenuInteractor,
  and gets a response back from the `PurchaseMenuPresenter`.
 */
final class PurchaseMenuViewController: UIViewController {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: PurchaseMenuViewControllerOutput!
    /// The `UIScrollView` that contains prominently displayed items that are shown in the
    /// purchase menu. This scrollView view contains a stackView which holds the elements.
    @IBOutlet private weak var prominentItemsScrollView: UIScrollView?
    /// The `UIStackView` that contains prominently displayed items that are shown in the
    /// purchase menu. This stack view needs to be filled with menu items.
    @IBOutlet private weak var prominentItemsStackView: UIStackView?
    /// The `UIStackView` that contains regularly displayed items that are shown in the
    /// purchase menu. This stack view needs to be filled with menu items.
    @IBOutlet private weak var regularItemsStackView: UIStackView?
    /// This property might contain a `Game` in case we have any information on which
    /// `Game` the user was interested in starting right now.
    var requestedGame: Game?
    /// A list of purchaseable items containing their respective views.
    private var presentedMenuItems: [PurchaseMenuItem] = []

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        highlightRequestedProducts()
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
        presentedMenuItems = []

        for index in 0..<viewModel.featuredProducts.count {
            guard let product = viewModel.featuredProducts[safe: index] else { continue }

            let itemView: PurchaseMenuItemView = .fromNib()
            itemView.update(with: .init(with: product, index: index))
            itemView.delegate = self
            prominentItemsStackView.addArrangedSubview(itemView)
            presentedMenuItems.append(.init(product: product, itemView: itemView))
        }

        for index in 0..<viewModel.regularProducts.count {
            guard let product = viewModel.regularProducts[safe: index] else { continue }

            let itemView: PurchaseMenuItemView = .fromNib()
            itemView.update(with: .init(with: product, index: index))
            itemView.delegate = self
            regularItemsStackView.addArrangedSubview(itemView)
            presentedMenuItems.append(.init(product: product, itemView: itemView))
        }
    }

    private func highlightRequestedProducts() {
        guard let requestedGame = self.requestedGame else { return }


        let menuItems = presentedMenuItems
            .filter { $0.product.included.contains(requestedGame) }

        if let prominentEntry = menuItems.first(
            where: {
                guard let itemView = $0.itemView else { return false }
                return prominentItemsStackView?.arrangedSubviews.contains(itemView) ?? false
            }
        ) {
            prominentItemsScrollView?.scrollRectToVisible(
                prominentEntry.itemView?.frame ?? .init(),
                animated: true
            )
        }
        menuItems.forEach { $0.itemView?.highlight() }
    }
}

// MARK: - PurchaseMenuPresenterOutput

extension PurchaseMenuViewController: PurchaseMenuPresenterOutput {

    // MARK: - Display logic

    func update(with viewModel: PurchaseMenuViewModel) {
        reloadData(with: viewModel)
    }
}

// MARK: - PurchaseMenuItemViewDelegate

extension PurchaseMenuViewController: PurchaseMenuItemViewDelegate {

    func didSelectPurchase(with product: Product) {
        output.purchaseSelected(with: product)
    }
}
