import UIKit
import Vision

enum ClassificationServiceError: Error {
    case buzy
    case noResults
}

class ClassificationServive {
    static let shared: ClassificationServive = .init()

    private var requests: [VNRequest] = []
    private var classificationCompletion: ((Result<String, Error>) -> Void)?

    private init() {
        // load MNIST model for the use with the Vision framework.
        guard let visionModel = try? VNCoreMLModel(for: MNISTClassifier().model) else {
            fatalError("can not load Vision ML model")
        }

        // Create a classification request and tell it to call
        // `handleClassification` once its done.
        let classificationRequest = VNCoreMLRequest(
            model: visionModel,
            completionHandler: self.handleClassification
        )

        // assigns the `classificationRequest` to the global requests array
        self.requests = [classificationRequest]
    }


    /// A classification function using the locally initialised ML model. Currently there can only
    /// be one classification at a time.
    ///
    /// - Parameters:
    ///   - image: The image that needs classification
    ///   - classificationCompletion: A completion which is being called on completion
    ///                               of the classification. This can contain A string representation
    ///                               of the classification result if available. Otherwise this will
    ///                               contain an error that can either be a Vision specific error
    ///                               or a `ClassificationServiceError` instance.
    func classify(
        image: UIImage,
        classificationCompletion: @escaping (Result<String, Error>) -> Void
    ) {
        // scale the image to the required size of 28x28 for better recognition results
        guard
            let scaledImage = scaleImage(
                image: image,
                toSize: CGSize(
                    width: 28,
                    height: 28
                )
            ),
            let noirImage = noir(image: scaledImage),
            let cgImage = noirImage.cgImage
        else { return }

        // create a handler that should perform the vision request
        let imageRequestHandler = VNImageRequestHandler(
            cgImage: cgImage,
            options: [:]
        )

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                self?.classificationCompletion = classificationCompletion
                try imageRequestHandler.perform(self?.requests ?? [])
            } catch {
                DispatchQueue.main.async {
                    self?.classificationCompletion?(.failure(error))
                    self?.classificationCompletion = nil
                }
            }
        }
    }

    private func handleClassification(
        request: VNRequest,
        error: Error?
    ) {
        guard let results = request.results else {
            return
        }

        // cast all elements to VNClassificationObservation objects
        // only choose observations with a confidence of more than 80%
        // only choose the identifier string to be placed into the classifications array.
        let classification = results
            .compactMap { $0 as? VNClassificationObservation }
            .sorted { $0.confidence > $1.confidence }
            .map { $0.identifier }
            .first

        DispatchQueue.main.async { [weak self] in
            if let classification = classification {
                self?.classificationCompletion?(.success(classification))
                self?.classificationCompletion = nil
            } else {
                self?.classificationCompletion?(.failure(ClassificationServiceError.noResults))
                self?.classificationCompletion = nil
            }
        }
    }

    // scales any UIImage to a desired target size
    private func scaleImage(
        image: UIImage,
        toSize size: CGSize
    ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    private func noir(
        image: UIImage
    ) -> UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(
            CIImage(image: image),
            forKey: kCIInputImageKey
        )
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(
                cgImage: cgImage,
                scale: image.scale,
                orientation: image.imageOrientation
            )
        }
        return nil
    }
}
