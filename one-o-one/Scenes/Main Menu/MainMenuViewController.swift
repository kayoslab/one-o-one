import UIKit

/**
  Data that will be directed out of the `MainMenuViewController`
  to the  `MainMenuInteractor`.
 */
protocol MainMenuViewControllerOutput {

    /// The `MainMenuViewController`'s view finished loading.
    func viewLoaded()

    /// A menu item was selected by the user.
    ///
    /// - Parameter with: The index of the selected menu item.
    func menuItemSelected(with index: Int)
}

/**
  The `MainMenuViewController` communicates with the `MainMenuInteractor,
  and gets a response back from the `MainMenuPresenter`.
 */
final class MainMenuViewController: UIViewController {

    // swiftlint:disable:next implicitly_unwrapped_optional
    var output: MainMenuViewControllerOutput!

    @IBOutlet private weak var stackView: UIStackView?

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

    /// Reload the stack views entries based on the available game items.
    /// This will automatically add the arranged subviews and request them
    /// to update their view autonomously.
    private func reloadData(with viewModel: MainMenuViewModel) {
        guard let stackView = self.stackView else { return }

        for index in 0..<viewModel.games.count {
            let itemView: MenuItemView = .fromNib()
            itemView.update(
                with: .init(
                    with: viewModel.games[index],
                    index: index
                )
            )
            itemView.delegate = self

            stackView.addArrangedSubview(itemView)
        }
    }
}

// MARK: - MainMenuPresenterOutput

extension MainMenuViewController: MainMenuPresenterOutput {

    // MARK: - Display logic

    func update(with viewModel: MainMenuViewModel) {
        reloadData(with: viewModel)
    }
}

extension MainMenuViewController: MenuItemViewDelegate {

    func didSelectMenuItem(with index: Int) {
        output.menuItemSelected(with: index)
    }
}
