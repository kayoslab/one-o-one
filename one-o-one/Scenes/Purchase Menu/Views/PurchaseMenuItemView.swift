import UIKit

protocol PurchaseMenuItemViewDelegate: class {
    func didSelectMenuItem(with index: Int)
}

class PurchaseMenuItemView: UIView {
    private var index: Int = 0

    weak var delegate: PurchaseMenuItemViewDelegate?

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

    }

    func wiggle() {
        let transformAnim = CAKeyframeAnimation(keyPath: "transform")
        transformAnim.values = [
            NSValue(
                caTransform3D: CATransform3DMakeRotation(0.04, 0.0, 0.0, 1.0)
            ),
            NSValue(
                caTransform3D: CATransform3DMakeRotation(-0.04, 0, 0, 1)
            )
        ]
        transformAnim.autoreverses = true
        transformAnim.duration = 0.115
        transformAnim.repeatCount = 15.0
        layer.add(transformAnim, forKey: "transform")
    }

    func update(with viewModel: PurchaseMenuItemViewModel) {
        backgroundColor = viewModel.backgroundColor
        index = viewModel.index
    }
}
