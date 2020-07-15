import UIKit


class CanvasView: UIView {

    private let viewModel: CanvasViewModel = .init()

    private var path: UIBezierPath?
    private var touchPoint: CGPoint?
    private var startingPoint: CGPoint?

    private var timer: Timer?
    private var fired: Bool {
        return !(timer?.isValid ?? true)
    }

    weak var output: UILabel?

    override func layoutSubviews() {
        super.layoutSubviews()

        // no lines should be visible outside of the view
        clipsToBounds = true
        // we only process one touch at a time
        isMultipleTouchEnabled = false
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard !fired else { return }

        timer?.invalidate()
        timer = nil

        // get the touch position when user starts drawing
        let touch = touches.first
        startingPoint = touch?.location(in: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard !fired else { return }

        // get the next touch point as the user draws
        let touch = touches.first
        touchPoint = touch?.location(in: self)

        // create path originating from the starting point to the next point the user reached
        let path = UIBezierPath()
        path.move(to: startingPoint ?? .init())
        path.addLine(to: touchPoint ?? .init())
        self.path = path

        // setting the startingPoint to the previous touchpoint
        // this updates while the user draws
        startingPoint = touchPoint

        // draws the actual line shapes
        drawShapeLayer()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard !fired else { return }

        let timer = Timer(timeInterval: 1.0, repeats: false) { _ in
            guard let image = UIImage(
                view: self
            ) else { return }
            ClassificationServive.shared.classify(
                image: image,
                classificationCompletion: { [weak self] result in
                    switch result {
                    case .success(let classification):
                        print("Classification: \(classification)")
                        self?.output?.text = classification
                    case .failure(let error):
                        dump(error)
                        self?.output?.text = "?"
                    }
                }
            )
        }
        self.timer = timer
        RunLoop.current.add(timer, forMode: .default)
    }

    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        // the shape layer is used to draw along the already created path
        shapeLayer.path = path?.cgPath

        // adjusting the shape to our wishes
        shapeLayer.strokeColor = viewModel.lineColor.cgColor
        shapeLayer.lineWidth = viewModel.lineWidth
        shapeLayer.fillColor = viewModel.fillColor.cgColor

        // adding the shapelayer to the vies layer and forcing a redraw
        layer.addSublayer(shapeLayer)
        setNeedsDisplay()
    }

//    /// Probably not necessary at this point since we'll just
//    /// discard the view after usage.
//    /// This function removes all drawings from the current
//    /// `CanvasView` object.
//    func clearCanvas() {
//        path?.removeAllPoints()
//        layer.sublayers = nil
//        setNeedsDisplay()
//    }
}
