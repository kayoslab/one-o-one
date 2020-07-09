import Foundation
import StoreKit

/// Defines the interaction between the `AppDelegate` and the `PurchaseService`.
/// This protocol contains functions that take care of the `SKPaymentQueue`.
protocol PurchaseServiceApplicationMainInteraction {
    /// Starts the purchase service. This function adds an observer to the
    /// `SKPaymentQueue.default()` queue.
    ///
    /// - Note: Your application should add an observer to the payment queue during
    ///         application initialization. If there are no observers attached to the queue,
    ///         the payment queue does not synchronize its list of pending transactions
    ///         with the Apple App Store, because there is no observer to respond to
    ///         updated transactions.
    ///         If an application quits when transactions are still being processed,
    ///         those transactions are not lost. The next time the application launches,
    ///         the payment queue resumes processing the transactions. Your application
    ///         should always expect to be notified of completed transactions.
    ///         If more than one transaction observer is attached to the payment queue,
    ///         no guarantees are made as to the order which they will be called.
    ///         It is safe for multiple observers to call `finishTransaction(_:)`,
    ///         but not recommended. It is recommended that you use a single observer
    ///         to process and finish the transaction.
    func start()

    /// Stops the purchase service. This function removes the observer from the
    /// `SKPaymentQueue.default()` queue.
    ///
    /// - Note: If there are no observers attached to the queue, the payment queue does
    ///         not synchronize its list of pending transactions with the Apple App Store,
    ///         because there is no observer to respond to updated transactions.
    func stop()
}

protocol PurchaseServices {

    func retrieveProducts()

    func buy(product: String)

    func restorePurchase()
}

class PurchaseService {
    static var shared: PurchaseService = .init()

    private let storeObserver: StoreObserver = .init()
    private let storeManager: StoreManager = .init()

    private enum Products: String, CaseIterable {
        case fullPackage = "oneoone.fullpackage"
        case substractions = "oneoone.subtractions"
        case multiplications = "oneoone.multiplications"
        case divisions = "oneoone.divisions"
    }

    private init() { }
}

extension PurchaseService: PurchaseServices {
    func retrieveProducts() {
        storeManager.startProductRequest(
            with: Products.allCases.map { $0.rawValue }
        )
    }

    func buy(product: String) {

    }

    func restorePurchase() {
        storeObserver.delegate = self
        storeObserver.restore()
    }
}

extension PurchaseService: StoreObserverDelegate {
    func storeObserverRestoreDidSucceed() {

    }
}

extension PurchaseService: StoreManagerDelegate {
    func storeManagerDidReceiveResponse(_ response: [Section]) {
        dump(response)
    }
}

extension PurchaseService: PurchaseServiceApplicationMainInteraction {
    func start() {
        SKPaymentQueue.default().add(storeObserver)
    }

    func stop() {
        SKPaymentQueue.default().remove(storeObserver)
    }
}
