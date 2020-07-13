import UIKit

protocol MainMenuItemViewDelegate: class {
    func didSelectMenuItem(with index: Int)
}

class MainMenuItemView: UIView {
    private var index: Int = 0

    weak var delegate: MainMenuItemViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        addConstraint(
            .init(
                item: self,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .height,
                multiplier: 1.0,
                constant: 0.0
            )
        )
    }
    @IBAction private func didTap(_ sender: UITapGestureRecognizer) {
        delegate?.didSelectMenuItem(with: index)
    }

    func update(with viewModel: MainMenuItemViewModel) {
        backgroundColor = viewModel.backgroundColor
        index = viewModel.index
    }
}
