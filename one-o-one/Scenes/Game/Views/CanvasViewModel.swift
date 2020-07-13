import UIKit

/**
  Stores all the models related to the `CanvasView`.
  The `CanvasViewModel's` class will be related to each component.
  The view model will contain Request, Response and ViewModel structs.
 */
struct CanvasViewModel {
    // Properties for line drawing
    var lineColor: UIColor = .white
    var fillColor: UIColor = .clear
    var lineWidth: CGFloat = 10.0
}
