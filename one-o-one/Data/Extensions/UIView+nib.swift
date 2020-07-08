import UIKit

/// A UIView extension to make it easier working with nib and code layouts at the same time.
public extension UIView {
    
    /// Unarchives the contents of a nib file.
    ///
    /// - Returns: The top-level objects in the nib file.
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(
            String(describing: T.self),
            owner: nil,
            options: nil
        // swiftlint:disable:next force_cast force_unwrapping
        )!.first as! T
    }

    /// Fits the view into into the superview by setting the appropriate constraints
    ///
    /// If you just call the function with the default parameters,
    ///
    ///     fitInSuperview()
    ///
    /// then the view gets the same size as it's superview, with constraints to all edges.
    ///
    /// If any of the **inset parameters** is **nil**, then the
    /// matching edge does not get any constraint!
    ///
    /// If any of the **inset parameters** is **negative**, then the subview
    /// is exceeding the superview. Depending on the superview's clipping behavior
    /// it may show beyond its borders
    ///
    /// If **widthToHeightRatio** is given, a ratio constraint is set. In this case, one of the other
    /// parameters should be nil, otherwise the view becomes overconstrained and will produce layout errors.
    ///
    /// - Parameter top: the inset to use for the top constraint
    /// - Parameter leading: the inset to use for the top constraint
    /// - Parameter trailing: the inset to use for the top constraint
    /// - Parameter bottom: the inset to use for the bottom constraint.
    /// - Parameter widthToHeightRatio: the width to height ratio
    /// **default: nil**
    func fitInSuperview(
        top: CGFloat? = 0,
        leading: CGFloat? = 0,
        trailing: CGFloat? = 0,
        bottom: CGFloat? = 0,
        widthToHeightRatio: CGFloat? = nil
    ) {
        guard superview != nil else { return }

        translatesAutoresizingMaskIntoConstraints = false
        removeConstraintsToSuperview()
        if let top = top {
            addConstraintToSuperview(
                attribute: .top,
                constant: top
            )
        }
        if let bottom = bottom {
            addConstraintToSuperview(
                attribute: .bottom,
                constant: -bottom
            )
        }
        if let leading = leading {
            addConstraintToSuperview(
                attribute: .leading,
                constant: -leading
            )
        }
        if let trailing = trailing {
            addConstraintToSuperview(
                attribute: .trailing,
                constant: trailing
            )
        }
        if let widthToHeightRatio = widthToHeightRatio {
            widthAnchor.constraint(
                equalTo: heightAnchor,
                multiplier: widthToHeightRatio
            ).isActive = true
        }
    }

    func addConstraintToSuperview(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) {
        guard let superview = self.superview else { return }

        NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: .equal,
            toItem: superview,
            attribute: attribute,
            multiplier: 1.0,
            constant: constant
        ).isActive = true
    }

    /// Remove all the constraints of self that are directly linked to the superview
    func removeConstraintsToSuperview() {
        guard let superview = self.superview else { return }

        for constraint in self.constraints {
            let items = [constraint.firstItem, constraint.secondItem]
            for item in items {
                if let view = item as? UIView, view == superview {
                    self.removeConstraint(constraint)
                }
            }
        }
    }
}
