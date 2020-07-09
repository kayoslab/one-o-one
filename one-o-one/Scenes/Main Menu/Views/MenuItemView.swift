import UIKit

protocol MenuItemViewDelegate: class {
    func didSelectMenuItem(with index: Int)
}

class MenuItemView: UIView {
    private var index: Int = 0

    weak var delegate: MenuItemViewDelegate?

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

    func update(with viewModel: MenuItemViewModel) {
        backgroundColor = viewModel.backgroundColor
        index = viewModel.index
    }
}
