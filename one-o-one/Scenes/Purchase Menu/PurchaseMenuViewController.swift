import UIKit

/**
  Data that will be directed out of the `PurchaseMenuViewController`
  to the  `PurchaseMenuInteractor`.
 */
protocol PurchaseMenuViewControllerOutput {

    /// The `PurchaseMenuViewController`'s view finished loading.
    func viewLoaded()

    /// The `PurchaseMenuViewController`'s view appeared
    func viewAppeared()

    /// Injects a requested `Game` into the module to know which game
    /// is relevant for the user.
    ///
    /// - Parameter requestedGame: The game, which the user wanted
    ///                            to run.
    func inject(requested requestedGame: Game)

    /// A new menu item was added to the purchase menu.
    ///
    /// - Parameters:
    ///   - product: The product related to the menu item.
    ///   - itemView: The menu item reference that was added.
    func presentedMenuItem(for product: Product, with itemView: PurchaseMenuItemView)

    /// A menu item was removed from the purchase menu.
    ///
    /// - Parameter itemView: The menu item reference that was removed.
    func removedMenuItem(with itemView: PurchaseMenuItemView)

    /// The user's has selected the close button.
    func closeButtonSelected()

    /// The user has selected a purchaseable `Product`.
    ///
    /// - Parameter product: The underlying product retrieved from
    ///                      the `PurchaseMenuItemView`.
    func purchaseSelected(with product: Product)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        output.viewAppeared()
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

        prominentItemsStackView.arrangedSubviews.forEach { [weak self] in
            prominentItemsStackView.removeArrangedSubview($0)

            guard let purchaseView = $0 as? PurchaseMenuItemView else { return }

            self?.output.removedMenuItem(with: purchaseView)
        }

        regularItemsStackView.arrangedSubviews.forEach { [weak self] in
            regularItemsStackView.removeArrangedSubview($0)

            guard let purchaseView = $0 as? PurchaseMenuItemView else { return }

            self?.output.removedMenuItem(with: purchaseView)
        }

        for index in 0..<viewModel.featuredProducts.count {
            guard let product = viewModel.featuredProducts[safe: index] else { continue }

            let itemView: PurchaseMenuItemView = .fromNib()
            itemView.update(with: .init(with: product, index: index))
            itemView.delegate = self
            prominentItemsStackView.addArrangedSubview(itemView)
            output.presentedMenuItem(for: product, with: itemView)
        }

        for index in 0..<viewModel.regularProducts.count {
            guard let product = viewModel.regularProducts[safe: index] else { continue }

            let itemView: PurchaseMenuItemView = .fromNib()
            itemView.update(with: .init(with: product, index: index))
            itemView.delegate = self
            regularItemsStackView.addArrangedSubview(itemView)
            output.presentedMenuItem(for: product, with: itemView)
        }

        prominentItemsStackView.setNeedsLayout()
        regularItemsStackView.setNeedsLayout()
        view.layoutSubviews()
    }

    func highlight(with highlights: [Product]) {
        guard
            let prominentItemsStackView = self.prominentItemsStackView,
            let regularItemsStackView = self.regularItemsStackView
        else { return }

        if let prominentItem = prominentItemsStackView.arrangedSubviews.first(
            where: {
                guard let purchaseView = $0 as? PurchaseMenuItemView else { return false }

                return highlights.contains(purchaseView.product)
            }
        ) as? PurchaseMenuItemView {
            prominentItem.highlight()
        }

        if let regularItem = regularItemsStackView.arrangedSubviews.first(
            where: {
                guard let purchaseView = $0 as? PurchaseMenuItemView else { return false }

                return highlights.contains(purchaseView.product)
            }
        ) as? PurchaseMenuItemView {
            regularItem.highlight()
        }
    }
}

// MARK: - PurchaseMenuPresenterOutput

extension PurchaseMenuViewController: PurchaseMenuPresenterOutput {

    // MARK: - Display logic

    func update(with viewModel: PurchaseMenuViewModel) {
        reloadData(with: viewModel)
        highlight(with: viewModel.highlightedMenuItems)
    }
}

// MARK: - PurchaseMenuItemViewDelegate

extension PurchaseMenuViewController: PurchaseMenuItemViewDelegate {

    func didSelectPurchase(with product: Product) {
        output.purchaseSelected(with: product)
    }
}
